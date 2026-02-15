-- ============================================================================
-- MIGRATION 005: Courts Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: quadras, quadras_bloqueios, manutencoes, equipamentos_quadra
-- Base: Legacy v1.0 (proper ENUMs for status/tipo)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- QUADRAS
-- ============================================================
CREATE TABLE quadras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(50) NOT NULL,
  tipo_esporte tipo_esporte NOT NULL,
  tipo_piso tipo_piso NOT NULL,
  cobertura BOOLEAN NOT NULL DEFAULT false,
  iluminacao BOOLEAN NOT NULL DEFAULT false,
  dimensoes JSONB,
  capacidade_jogadores INTEGER NOT NULL,
  valor_hora_pico DECIMAL(8,2) NOT NULL,
  valor_hora_normal DECIMAL(8,2) NOT NULL,
  horarios_pico JSONB NOT NULL DEFAULT '{}',
  equipamentos_inclusos JSONB DEFAULT '[]',
  observacoes TEXT,
  status status_quadra NOT NULL DEFAULT 'ativa',    -- ENUM restaurado do v1.0
  ultima_manutencao DATE,
  proxima_manutencao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- BLOQUEIOS DE QUADRA
-- ============================================================
CREATE TABLE quadras_bloqueios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_bloqueio tipo_bloqueio NOT NULL,               -- ENUM restaurado do v1.0
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  responsavel_id UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status status_bloqueio NOT NULL DEFAULT 'ativo',    -- ENUM restaurado do v1.0
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- MANUTENCOES
-- ============================================================
CREATE TABLE manutencoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_manutencao tipo_manutencao NOT NULL,            -- ENUM restaurado do v1.0
  data_manutencao DATE NOT NULL,
  descricao TEXT NOT NULL,
  fornecedor VARCHAR(100),
  valor_gasto DECIMAL(8,2),
  tempo_parada INTEGER,                                -- em horas
  responsavel_id UUID REFERENCES usuarios(id),
  proximo_agendamento DATE,
  anexos JSONB DEFAULT '[]',
  status status_manutencao NOT NULL DEFAULT 'concluida', -- ENUM restaurado do v1.0
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- EQUIPAMENTOS DA QUADRA
-- ============================================================
CREATE TABLE equipamentos_quadra (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  nome_equipamento VARCHAR(100) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  marca VARCHAR(50),
  modelo VARCHAR(50),
  data_aquisicao DATE,
  valor_aquisicao DECIMAL(8,2),
  vida_util_estimada INTEGER,                          -- em meses
  status VARCHAR(20) NOT NULL DEFAULT 'novo',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
