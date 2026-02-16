-- ============================================================================
-- MIGRATION 006: Scheduling Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: agendamentos, checkins, lista_espera, agendamentos_recorrentes
-- Base: v2.0 enhanced structure (GENERATED columns, inline recurrence)
--        + v1.0 proper ENUMs
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- AGENDAMENTOS (tabela central de reservas)
-- Usa estrutura v2.0 com GENERATED columns e campos expandidos
-- ============================================================
CREATE TABLE agendamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id),

  -- Responsavel pelo agendamento
  criado_por_id UUID REFERENCES usuarios(id),
  cliente_principal_id UUID REFERENCES usuarios(id),

  -- Data e horario
  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  duracao_minutos INTEGER GENERATED ALWAYS AS (
    (EXTRACT(EPOCH FROM (hora_fim - hora_inicio)) / 60)::INTEGER
  ) STORED,

  -- Tipo e configuracoes
  tipo tipo_agendamento NOT NULL DEFAULT 'avulso',
  modalidade tipo_esporte NOT NULL,

  -- Participantes
  participantes JSONB DEFAULT '[]',
  max_participantes INTEGER DEFAULT 4,
  lista_espera JSONB DEFAULT '[]',

  -- Valores
  valor_total DECIMAL(8,2) NOT NULL DEFAULT 0,
  valor_por_pessoa DECIMAL(8,2),
  desconto_aplicado DECIMAL(8,2) DEFAULT 0,
  valor_final DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_total - COALESCE(desconto_aplicado, 0)
  ) STORED,
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,

  -- Status e observacoes
  status status_agendamento NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  observacoes_internas TEXT,

  -- Recorrencia
  e_recorrente BOOLEAN DEFAULT false,
  recorrencia_config JSONB DEFAULT '{}',
  agendamento_pai_id UUID REFERENCES agendamentos(id),

  -- Check-ins e controle
  permite_checkin BOOLEAN DEFAULT true,
  checkin_aberto_em TIMESTAMPTZ,
  checkin_fechado_em TIMESTAMPTZ,
  checkins JSONB DEFAULT '[]',

  -- Comunicacao
  notificacoes_enviadas JSONB DEFAULT '[]',
  lembrete_enviado BOOLEAN DEFAULT false,

  -- Cancelamento
  data_cancelamento TIMESTAMPTZ,
  motivo_cancelamento TEXT,
  cancelado_por_id UUID REFERENCES usuarios(id),

  -- Integracao Asaas
  asaas_payment_id VARCHAR(100),

  -- Metadados
  confirmado_em TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CHECK (hora_fim > hora_inicio),
  CHECK (valor_total >= 0),
  CHECK (max_participantes > 0)
);

-- ============================================================
-- CHECK-INS
-- ============================================================
CREATE TABLE checkins (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id),
  tipo_checkin tipo_checkin NOT NULL,
  data_checkin TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  localizacao POINT,
  dispositivo_info JSONB,
  responsavel_checkin UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status status_checkin NOT NULL DEFAULT 'presente',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- LISTA DE ESPERA
-- ============================================================
CREATE TABLE lista_espera (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id),
  cliente_id UUID REFERENCES usuarios(id),
  data_desejada DATE NOT NULL,
  hora_inicio_desejada TIME NOT NULL,
  hora_fim_desejada TIME NOT NULL,
  flexibilidade_horario JSONB,
  data_solicitacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  prioridade INTEGER NOT NULL DEFAULT 1,
  notificado BOOLEAN NOT NULL DEFAULT false,
  data_notificacao TIMESTAMPTZ,
  prazo_resposta TIMESTAMPTZ,
  aceite_automatico BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(20) NOT NULL DEFAULT 'aguardando',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- AGENDAMENTOS RECORRENTES
-- ============================================================
CREATE TABLE agendamentos_recorrentes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id),
  cliente_id UUID REFERENCES usuarios(id),
  tipo_recorrencia VARCHAR(20) NOT NULL,
  dias_semana JSONB NOT NULL DEFAULT '[]',
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  data_inicio_periodo DATE NOT NULL,
  data_fim_periodo DATE,
  valor_total_periodo DECIMAL(8,2) NOT NULL,
  forma_pagamento forma_pagamento NOT NULL,
  status status_geral NOT NULL DEFAULT 'ativo',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
