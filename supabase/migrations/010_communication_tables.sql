-- ============================================================================
-- MIGRATION 010: Communication and Integration Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: notificacoes, campanhas, historico_comunicacoes,
--         templates_comunicacao, templates_whatsapp,
--         integracao_whatsapp, integracao_asaas,
--         automacoes_n8n, logs_execucao,
--         configuracoes_backup, configuracoes_push
-- Base: Legacy v1.0 (todas tabelas presentes - estavam AUSENTES no v2.0)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- NOTIFICACOES
-- ============================================================
CREATE TABLE notificacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  usuario_destinatario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo_notificacao tipo_notificacao NOT NULL,
  titulo VARCHAR(150) NOT NULL,
  mensagem TEXT NOT NULL,
  dados_extras JSONB,
  canal_envio canal_envio NOT NULL,
  prioridade prioridade NOT NULL DEFAULT 'media',
  agendada_para TIMESTAMPTZ,
  enviada_em TIMESTAMPTZ,
  lida_em TIMESTAMPTZ,
  acao_executada BOOLEAN NOT NULL DEFAULT false,
  status status_notificacao NOT NULL DEFAULT 'pendente',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CAMPANHAS DE MARKETING
-- ============================================================
CREATE TABLE campanhas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_campanha VARCHAR(100) NOT NULL,
  tipo_campanha tipo_campanha NOT NULL,
  publico_alvo JSONB NOT NULL,
  canais_envio JSONB NOT NULL DEFAULT '[]',
  conteudo_mensagem TEXT NOT NULL,
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ,
  total_destinatarios INTEGER NOT NULL DEFAULT 0,
  enviados INTEGER NOT NULL DEFAULT 0,
  abertos INTEGER NOT NULL DEFAULT 0,
  cliques INTEGER NOT NULL DEFAULT 0,
  conversoes INTEGER NOT NULL DEFAULT 0,
  status status_campanha NOT NULL DEFAULT 'rascunho',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- HISTORICO DE COMUNICACOES
-- ============================================================
CREATE TABLE historico_comunicacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo_comunicacao tipo_comunicacao NOT NULL,
  assunto VARCHAR(200) NOT NULL,
  conteudo TEXT NOT NULL,
  remetente VARCHAR(100) NOT NULL,
  data_envio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_entrega TIMESTAMPTZ,
  data_leitura TIMESTAMPTZ,
  status_entrega status_entrega NOT NULL DEFAULT 'enviado',
  anexos JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TEMPLATES DE COMUNICACAO
-- ============================================================
CREATE TABLE templates_comunicacao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_template VARCHAR(100) NOT NULL,
  tipo_template tipo_template NOT NULL,
  canal canal_envio NOT NULL,
  assunto VARCHAR(200),
  conteudo TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TEMPLATES WHATSAPP (templates especificos para WhatsApp)
-- ============================================================
CREATE TABLE templates_whatsapp (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_template VARCHAR(100) NOT NULL,
  tipo_template tipo_template NOT NULL,
  gatilho VARCHAR(50) NOT NULL,
  mensagem TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT true,
  enviados_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INTEGRACAO WHATSAPP (Evolution API)
-- //HIGH-RISK - credenciais de integracao
-- ============================================================
CREATE TABLE integracao_whatsapp (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  api_key VARCHAR(200) NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  numero_whatsapp VARCHAR(15) NOT NULL,
  nome_instancia VARCHAR(50) NOT NULL,
  status_conexao status_conexao NOT NULL DEFAULT 'desconectado',
  ultimo_teste TIMESTAMPTZ,
  templates_configurados JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT false,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INTEGRACAO ASAAS (Pagamentos)
-- //HIGH-RISK - credenciais de pagamento
-- ============================================================
CREATE TABLE integracao_asaas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  api_key VARCHAR(200) NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  ambiente ambiente NOT NULL DEFAULT 'sandbox',
  status_conexao status_conexao NOT NULL DEFAULT 'desconectado',
  ultimo_teste TIMESTAMPTZ,
  configuracoes_cobranca JSONB NOT NULL DEFAULT '{}',
  taxa_personalizada DECIMAL(5,2),
  ativo BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- AUTOMACOES N8N
-- ============================================================
CREATE TABLE automacoes_n8n (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_automacao VARCHAR(100) NOT NULL,
  tipo_trigger tipo_trigger NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  workflow_id VARCHAR(50),
  parametros JSONB,
  ultima_execucao TIMESTAMPTZ,
  total_execucoes INTEGER NOT NULL DEFAULT 0,
  ativo BOOLEAN NOT NULL DEFAULT false,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- LOGS DE EXECUCAO (logs das automacoes n8n)
-- ============================================================
CREATE TABLE logs_execucao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  automacao_id UUID REFERENCES automacoes_n8n(id) ON DELETE CASCADE,
  data_execucao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  payload_enviado JSONB,
  resposta_recebida JSONB,
  status VARCHAR(20) NOT NULL,
  tempo_execucao INTEGER,                              -- em milissegundos
  erro_detalhes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CONFIGURACOES DE BACKUP
-- ============================================================
CREATE TABLE configuracoes_backup (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  frequencia_backup VARCHAR(20) NOT NULL,
  tipos_dados JSONB NOT NULL DEFAULT '[]',
  local_armazenamento VARCHAR(50) NOT NULL,
  retencao_dias INTEGER NOT NULL DEFAULT 30,
  ultimo_backup TIMESTAMPTZ,
  proximo_backup TIMESTAMPTZ NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CONFIGURACOES PUSH (notificacoes push)
-- ============================================================
CREATE TABLE configuracoes_push (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_notificacao tipo_notificacao NOT NULL,
  titulo_padrao VARCHAR(100) NOT NULL,
  mensagem_padrao TEXT NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true,
  usuarios_alvo JSONB DEFAULT '[]',
  horario_envio JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
