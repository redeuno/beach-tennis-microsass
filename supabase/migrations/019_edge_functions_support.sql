-- ============================================================================
-- MIGRATION 019: Edge Functions Support + AI Integration
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Removes n8n dependency, adds pg_cron + pg_net, message queue, AI tables
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- EXTENSOES: pg_cron e pg_net para automacoes nativas
-- pg_cron: agendamento de tarefas (substitui n8n cron)
-- pg_net: chamadas HTTP de dentro do banco (trigger -> Edge Function)
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "pg_cron";
CREATE EXTENSION IF NOT EXISTS "pg_net";

-- Dar permissao ao pg_cron para rodar no schema public
GRANT USAGE ON SCHEMA cron TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cron TO postgres;

-- ============================================================
-- NOVOS ENUMs
-- ============================================================

-- Status da fila de mensagens
CREATE TYPE status_fila AS ENUM (
  'pendente', 'processando', 'enviado', 'erro', 'cancelado'
);

-- Tipo de automacao (substitui tipo_trigger que era n8n-specific)
CREATE TYPE tipo_automacao AS ENUM (
  'evento_banco', 'cron_agendado', 'webhook_externo', 'manual'
);

-- Status de execucao de automacao
CREATE TYPE status_execucao AS ENUM (
  'sucesso', 'erro', 'timeout', 'ignorado'
);

-- Canal de chatbot
CREATE TYPE canal_chatbot AS ENUM (
  'whatsapp', 'web', 'app'
);

-- ============================================================
-- RENOMEAR automacoes_n8n -> automacoes
-- Mantém a estrutura mas desacopla de n8n
-- ============================================================
ALTER TABLE automacoes_n8n RENAME TO automacoes;

-- Remover coluna workflow_id (era n8n-specific)
ALTER TABLE automacoes RENAME COLUMN webhook_url TO endpoint_url;
ALTER TABLE automacoes DROP COLUMN IF EXISTS workflow_id;

-- Adicionar colunas para Edge Functions
ALTER TABLE automacoes
  ADD COLUMN IF NOT EXISTS edge_function_name VARCHAR(100),
  ADD COLUMN IF NOT EXISTS cron_expression VARCHAR(50),
  ADD COLUMN IF NOT EXISTS descricao TEXT,
  ADD COLUMN IF NOT EXISTS ultima_execucao_status status_execucao;

-- ============================================================
-- ATUALIZAR logs_execucao FK (agora referencia automacoes)
-- A FK ja foi renomeada automaticamente com a tabela
-- Adicionar campos uteis
-- ============================================================
ALTER TABLE logs_execucao
  ADD COLUMN IF NOT EXISTS arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS edge_function VARCHAR(100),
  ADD COLUMN IF NOT EXISTS tipo_automacao tipo_automacao;

-- ============================================================
-- FILA DE MENSAGENS (message queue para WhatsApp/Email/SMS)
-- Evita rate limiting, permite retry, garante entrega
-- ============================================================
CREATE TABLE fila_mensagens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  canal canal_envio NOT NULL,
  destinatario VARCHAR(200) NOT NULL,
  destinatario_nome VARCHAR(150),
  usuario_id UUID REFERENCES usuarios(id),
  template_id UUID,
  assunto VARCHAR(200),
  conteudo TEXT NOT NULL,
  variaveis JSONB DEFAULT '{}',
  prioridade prioridade NOT NULL DEFAULT 'media',
  status status_fila NOT NULL DEFAULT 'pendente',
  tentativas INTEGER NOT NULL DEFAULT 0,
  max_tentativas INTEGER NOT NULL DEFAULT 3,
  agendado_para TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processado_em TIMESTAMPTZ,
  erro_mensagem TEXT,
  external_id VARCHAR(200),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CHATBOT CONVERSAS (historico de conversas AI)
-- ============================================================
CREATE TABLE chatbot_conversas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  canal canal_chatbot NOT NULL DEFAULT 'whatsapp',
  telefone_cliente VARCHAR(20),
  usuario_id UUID REFERENCES usuarios(id),
  nome_cliente VARCHAR(150),
  status status_geral NOT NULL DEFAULT 'ativo',
  contexto JSONB DEFAULT '{}',
  total_mensagens INTEGER NOT NULL DEFAULT 0,
  ultima_mensagem_em TIMESTAMPTZ,
  atendente_humano_id UUID REFERENCES usuarios(id),
  escalado_para_humano BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CHATBOT MENSAGENS (cada mensagem na conversa)
-- ============================================================
CREATE TABLE chatbot_mensagens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversa_id UUID NOT NULL REFERENCES chatbot_conversas(id) ON DELETE CASCADE,
  remetente VARCHAR(20) NOT NULL,
  conteudo TEXT NOT NULL,
  tipo VARCHAR(20) NOT NULL DEFAULT 'texto',
  intent_detectado VARCHAR(100),
  confianca_intent DECIMAL(3,2),
  acao_executada VARCHAR(100),
  acao_resultado JSONB,
  tokens_usados INTEGER,
  modelo_ai VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INSIGHTS ARENA (insights gerados por AI)
-- ============================================================
CREATE TABLE insights_arena (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  tipo VARCHAR(50) NOT NULL,
  titulo VARCHAR(200) NOT NULL,
  conteudo TEXT NOT NULL,
  dados_referencia JSONB DEFAULT '{}',
  prioridade prioridade NOT NULL DEFAULT 'media',
  acao_sugerida TEXT,
  lido BOOLEAN NOT NULL DEFAULT false,
  lido_em TIMESTAMPTZ,
  periodo_referencia DATE,
  modelo_ai VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CRON JOBS: Registrar os agendamentos via pg_cron
-- Estes serao executados automaticamente pelo PostgreSQL
-- Cada job chama uma Edge Function via pg_net
-- ============================================================
-- NOTA: Os SELECT cron.schedule() abaixo devem ser executados
-- APOS deploy das Edge Functions. As URLs serao configuradas
-- via variaveis de ambiente do Supabase.
-- Por enquanto, criamos a tabela de referencia dos jobs planejados.

CREATE TABLE cron_jobs_config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL UNIQUE,
  descricao TEXT NOT NULL,
  cron_expression VARCHAR(50) NOT NULL,
  edge_function_name VARCHAR(100) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT false,
  ultima_execucao TIMESTAMPTZ,
  proxima_execucao TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Inserir cron jobs planejados (serao ativados apos deploy das Edge Functions)
INSERT INTO cron_jobs_config (nome, descricao, cron_expression, edge_function_name) VALUES
  ('cron-billing', 'Gera faturas para contratos ativos, cria cobranças no Asaas D-3 do vencimento', '0 6 * * *', 'cron-billing'),
  ('cron-reminders', 'Envia lembretes: aula em 2h, fatura em 3 dias, agendamento amanha', '*/30 * * * *', 'cron-reminders'),
  ('cron-overdue', 'Sequencia de cobranca escalonada: D+1, D+3, D+7, D+15', '0 9 * * *', 'cron-overdue'),
  ('cron-lifecycle', 'Gerencia ciclo SaaS: expira trials, marca inadimplentes, gera metricas', '30 0 * * *', 'cron-lifecycle'),
  ('cron-process-queue', 'Processa fila de mensagens (WhatsApp, Email, SMS)', '*/1 * * * *', 'cron-process-queue'),
  ('cron-ai-insights', 'Gera insights diarios por AI para cada arena ativa', '0 5 * * *', 'cron-ai-insights'),
  ('cron-birthday', 'Envia mensagens de aniversario', '0 8 * * *', 'cron-birthday');

