-- ============================================================================
-- MIGRATION 003: Platform Tables (Super Admin)
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: planos_sistema, modulos_sistema, arenas, arenas_planos,
--         faturas_sistema, arena_modulos, relatorios_sistema, arena_relatorios_config
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- PLANOS DO SISTEMA (gerenciados pelo Super Admin)
-- ============================================================
CREATE TABLE planos_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL,
  valor_mensal DECIMAL(8,2) NOT NULL,
  max_quadras INTEGER NOT NULL DEFAULT 10,
  max_usuarios INTEGER NOT NULL DEFAULT 100,
  modulos_inclusos JSONB NOT NULL DEFAULT '[]',
  recursos_extras JSONB DEFAULT '{}',
  descricao TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- MODULOS DO SISTEMA (catalogo de modulos disponiveis)
-- ============================================================
CREATE TABLE modulos_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL UNIQUE,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tipo tipo_modulo NOT NULL,
  descricao TEXT NOT NULL,
  icone VARCHAR(100),
  ordem INTEGER NOT NULL DEFAULT 0,
  status status_modulo NOT NULL DEFAULT 'ativo',
  dependencias JSONB DEFAULT '[]',
  configuracoes_padrao JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ARENAS (tenants do sistema)
-- ============================================================
CREATE TABLE arenas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  razao_social VARCHAR(200) NOT NULL,
  cnpj VARCHAR(18) NOT NULL UNIQUE,
  telefone VARCHAR(15) NOT NULL,
  whatsapp VARCHAR(15) NOT NULL,
  email VARCHAR(100) NOT NULL,
  endereco_completo JSONB NOT NULL,
  coordenadas POINT,
  logo_url TEXT,
  cores_tema JSONB DEFAULT '{"primary": "#0066CC", "secondary": "#FF6B35"}',
  horario_funcionamento JSONB NOT NULL,
  configuracoes JSONB DEFAULT '{}',
  status status_geral NOT NULL DEFAULT 'ativo',
  plano_sistema_id UUID REFERENCES planos_sistema(id),
  data_vencimento DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ARENAS_PLANOS (historico de planos contratados por arena)
-- ============================================================
CREATE TABLE arenas_planos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  plano_sistema_id UUID REFERENCES planos_sistema(id),
  modulos_ativos JSONB NOT NULL DEFAULT '[]',
  modulos_bloqueados JSONB DEFAULT '[]',
  data_inicio DATE NOT NULL,
  data_vencimento DATE NOT NULL,
  valor_pago DECIMAL(8,2) NOT NULL,
  status status_geral NOT NULL DEFAULT 'ativo',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- FATURAS DO SISTEMA (cobranca da plataforma para arenas)
-- //HIGH-RISK - lida com cobranca financeira
-- ============================================================
CREATE TABLE faturas_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  referencia_mes DATE NOT NULL,
  valor_plano DECIMAL(8,2) NOT NULL,
  valor_extras DECIMAL(8,2) DEFAULT 0,
  valor_total DECIMAL(8,2) NOT NULL,
  data_vencimento DATE NOT NULL,
  data_pagamento TIMESTAMPTZ,
  status status_fatura NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ARENA_MODULOS (modulos liberados por arena)
-- ============================================================
CREATE TABLE arena_modulos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  modulo_id UUID REFERENCES modulos_sistema(id) ON DELETE CASCADE,
  ativo BOOLEAN NOT NULL DEFAULT true,
  configuracoes JSONB DEFAULT '{}',
  data_ativacao TIMESTAMPTZ DEFAULT NOW(),
  data_desativacao TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, modulo_id)
);

-- ============================================================
-- RELATORIOS DO SISTEMA (catalogo de relatorios disponiveis)
-- ============================================================
CREATE TABLE relatorios_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tipo tipo_relatorio NOT NULL,
  descricao TEXT,
  nivel_minimo nivel_acesso_relatorio NOT NULL,
  modulo_id UUID REFERENCES modulos_sistema(id),
  query_base TEXT,
  parametros JSONB DEFAULT '{}',
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ARENA_RELATORIOS_CONFIG (visibilidade de relatorios por arena)
-- ============================================================
CREATE TABLE arena_relatorios_config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  relatorio_id UUID REFERENCES relatorios_sistema(id) ON DELETE CASCADE,
  nivel_acesso nivel_acesso_relatorio NOT NULL,
  visivel_para_professores BOOLEAN DEFAULT false,
  visivel_para_alunos BOOLEAN DEFAULT false,
  configuracoes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, relatorio_id, nivel_acesso)
);
