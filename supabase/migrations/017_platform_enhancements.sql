-- ============================================================================
-- MIGRATION 017: Platform Enhancements
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Addresses: Multi-arena ownership, SaaS lifecycle, platform admin tools,
--            webhook tracking, usage monitoring, announcements
-- //HIGH-RISK - structural changes to core tables
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- NOVOS ENUMs
-- ============================================================

-- Status de assinatura da arena (ciclo de vida SaaS)
CREATE TYPE status_assinatura AS ENUM (
  'trial', 'ativa', 'inadimplente', 'suspensa', 'cancelada'
);

-- Tipos de evento do ciclo de vida da assinatura
CREATE TYPE tipo_evento_assinatura AS ENUM (
  'criacao', 'ativacao', 'trial_inicio', 'trial_fim',
  'pagamento', 'inadimplencia', 'suspensao', 'cancelamento', 'reativacao'
);

-- Tipos de webhook recebido
CREATE TYPE tipo_webhook AS ENUM (
  'payment_received', 'payment_overdue', 'payment_refunded', 'payment_deleted',
  'subscription_created', 'subscription_updated', 'subscription_cancelled',
  'transfer_received', 'charge_created', 'charge_updated'
);

-- Status de processamento de webhook
CREATE TYPE status_webhook AS ENUM (
  'recebido', 'processando', 'processado', 'erro', 'ignorado'
);

-- Tipos de anuncio da plataforma
CREATE TYPE tipo_anuncio AS ENUM (
  'novidade', 'manutencao', 'alerta', 'promocao', 'atualizacao'
);

-- Papel do usuario dentro de uma arena especifica (junction table)
CREATE TYPE papel_arena AS ENUM (
  'proprietario', 'admin', 'funcionario', 'professor', 'aluno'
);

-- ============================================================
-- USUARIOS_ARENAS (junction table: usuario <-> multiplas arenas)
-- Permite que um usuario (especialmente proprietario) gerencie
-- multiplas arenas com um unico login e troca de contexto
-- ============================================================
CREATE TABLE usuarios_arenas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  papel papel_arena NOT NULL DEFAULT 'aluno',
  is_proprietario BOOLEAN NOT NULL DEFAULT false,
  arena_ativa BOOLEAN NOT NULL DEFAULT false,
  data_vinculo DATE NOT NULL DEFAULT CURRENT_DATE,
  data_desvinculo DATE,
  status status_geral NOT NULL DEFAULT 'ativo',
  convite_aceito BOOLEAN NOT NULL DEFAULT true,
  convite_token VARCHAR(100),
  permissoes_customizadas JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Um usuario so pode ter um vinculo por arena
  UNIQUE(usuario_id, arena_id)
);

-- ============================================================
-- ALTER ARENAS: Adicionar campos de assinatura e white-label
-- ============================================================
ALTER TABLE arenas
  ADD COLUMN IF NOT EXISTS subdomain VARCHAR(63),
  ADD COLUMN IF NOT EXISTS custom_domain VARCHAR(255),
  ADD COLUMN IF NOT EXISTS favicon_url TEXT,
  ADD COLUMN IF NOT EXISTS email_remetente VARCHAR(150),
  ADD COLUMN IF NOT EXISTS status_assinatura status_assinatura NOT NULL DEFAULT 'trial',
  ADD COLUMN IF NOT EXISTS is_trial BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS trial_dias INTEGER NOT NULL DEFAULT 14,
  ADD COLUMN IF NOT EXISTS trial_iniciado_em TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS trial_finalizado_em TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS data_primeira_ativacao TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS onboarding_completado BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS onboarding_step INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS onboarding_data JSONB DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS mrr_atual DECIMAL(8,2) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_usuarios_ativos INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS ultimo_pagamento_em TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS proximo_vencimento DATE,
  ADD COLUMN IF NOT EXISTS dias_inadimplente INTEGER DEFAULT 0;

-- Subdomain deve ser unico
ALTER TABLE arenas ADD CONSTRAINT arenas_subdomain_unique UNIQUE (subdomain);
ALTER TABLE arenas ADD CONSTRAINT arenas_custom_domain_unique UNIQUE (custom_domain);

-- ============================================================
-- EVENTOS_ASSINATURA (ciclo de vida SaaS de cada arena)
-- //HIGH-RISK - tracking de receita e churn
-- ============================================================
CREATE TABLE eventos_assinatura (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  tipo tipo_evento_assinatura NOT NULL,
  status_anterior status_assinatura,
  status_novo status_assinatura,
  plano_anterior_id UUID REFERENCES planos_sistema(id),
  plano_novo_id UUID REFERENCES planos_sistema(id),
  valor DECIMAL(8,2),
  motivo TEXT,
  metadata JSONB DEFAULT '{}',
  executado_por UUID REFERENCES usuarios(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- WEBHOOK_EVENTS (log de webhooks recebidos - Asaas, etc)
-- //HIGH-RISK - reconciliacao financeira
-- ============================================================
CREATE TABLE webhook_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  provider VARCHAR(50) NOT NULL,
  tipo tipo_webhook NOT NULL,
  external_id VARCHAR(200),
  payload JSONB NOT NULL,
  status status_webhook NOT NULL DEFAULT 'recebido',
  arena_id UUID REFERENCES arenas(id),
  tentativas INTEGER NOT NULL DEFAULT 0,
  max_tentativas INTEGER NOT NULL DEFAULT 3,
  erro_mensagem TEXT,
  processado_em TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- USO_PLATAFORMA (tracking de uso por arena para limites de plano)
-- ============================================================
CREATE TABLE uso_plataforma (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID NOT NULL REFERENCES arenas(id) ON DELETE CASCADE,
  periodo DATE NOT NULL,
  total_usuarios INTEGER NOT NULL DEFAULT 0,
  total_agendamentos INTEGER NOT NULL DEFAULT 0,
  total_aulas INTEGER NOT NULL DEFAULT 0,
  total_faturas INTEGER NOT NULL DEFAULT 0,
  total_torneios INTEGER NOT NULL DEFAULT 0,
  total_notificacoes_enviadas INTEGER NOT NULL DEFAULT 0,
  total_whatsapp_enviados INTEGER NOT NULL DEFAULT 0,
  storage_usado_mb DECIMAL(10,2) DEFAULT 0,
  api_calls INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, periodo)
);

-- ============================================================
-- ANUNCIOS_PLATAFORMA (comunicacao do super admin com arena owners)
-- ============================================================
CREATE TABLE anuncios_plataforma (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  titulo VARCHAR(200) NOT NULL,
  conteudo TEXT NOT NULL,
  tipo tipo_anuncio NOT NULL DEFAULT 'novidade',
  prioridade prioridade NOT NULL DEFAULT 'media',
  ativo BOOLEAN NOT NULL DEFAULT true,
  data_inicio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_fim TIMESTAMPTZ,
  destinatarios_plano JSONB DEFAULT '[]',
  destinatarios_arena JSONB DEFAULT '[]',
  criado_por UUID REFERENCES usuarios(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ANUNCIOS_LIDOS (tracking de leitura dos anuncios)
-- ============================================================
CREATE TABLE anuncios_lidos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  anuncio_id UUID NOT NULL REFERENCES anuncios_plataforma(id) ON DELETE CASCADE,
  usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  lido_em TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(anuncio_id, usuario_id)
);

-- ============================================================
-- METRICAS_PLATAFORMA (snapshot diario de metricas SaaS)
-- //HIGH-RISK - dados de receita consolidados
-- ============================================================
CREATE TABLE metricas_plataforma (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  data_referencia DATE NOT NULL UNIQUE,
  total_arenas INTEGER NOT NULL DEFAULT 0,
  arenas_ativas INTEGER NOT NULL DEFAULT 0,
  arenas_trial INTEGER NOT NULL DEFAULT 0,
  arenas_inadimplentes INTEGER NOT NULL DEFAULT 0,
  arenas_canceladas INTEGER NOT NULL DEFAULT 0,
  mrr DECIMAL(10,2) NOT NULL DEFAULT 0,
  arr DECIMAL(12,2) NOT NULL DEFAULT 0,
  churn_rate DECIMAL(5,2) DEFAULT 0,
  novos_trials INTEGER NOT NULL DEFAULT 0,
  conversoes_trial INTEGER NOT NULL DEFAULT 0,
  total_usuarios_plataforma INTEGER NOT NULL DEFAULT 0,
  receita_mes DECIMAL(10,2) DEFAULT 0,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

