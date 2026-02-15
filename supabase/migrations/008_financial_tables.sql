-- ============================================================================
-- MIGRATION 008: Financial Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: planos, contratos, faturas, comissoes_professores,
--         detalhes_comissoes, movimentacoes, formas_pagamento
-- Base: v2.0 enhanced (GENERATED columns) + v1.0 tables completas
-- ============================================================================
-- //AI-GENERATED
-- //HIGH-RISK - todas as tabelas lidam com dados financeiros

-- ============================================================
-- PLANOS DE PAGAMENTO (planos de mensalidade da arena para alunos)
-- Diferente de planos_sistema que e da plataforma para arenas
-- ============================================================
CREATE TABLE planos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(100) NOT NULL,
  tipo_plano tipo_plano NOT NULL,
  valor DECIMAL(8,2) NOT NULL,
  beneficios JSONB NOT NULL DEFAULT '[]',
  limitacoes JSONB DEFAULT '[]',
  descricao TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CONTRATOS (contratos de mensalidade aluno-arena)
-- Usa estrutura v2.0 com GENERATED columns e campos expandidos
-- ============================================================
CREATE TABLE contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  plano_id UUID REFERENCES planos(id),
  vendedor_id UUID REFERENCES usuarios(id),

  -- Dados do contrato
  numero_contrato VARCHAR(50) NOT NULL,
  tipo_plano tipo_plano NOT NULL,
  modalidade tipo_esporte NOT NULL,

  -- Datas
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_vencimento_mensalidade INTEGER NOT NULL DEFAULT 10,

  -- Valores
  valor_mensalidade DECIMAL(8,2) NOT NULL,
  valor_taxa_adesao DECIMAL(8,2) DEFAULT 0,
  desconto_percentual DECIMAL(5,2) DEFAULT 0,
  valor_desconto DECIMAL(8,2) DEFAULT 0,
  valor_final_mensalidade DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_mensalidade - COALESCE(valor_desconto, 0) - (valor_mensalidade * COALESCE(desconto_percentual, 0) / 100)
  ) STORED,

  -- Beneficios inclusos
  aulas_incluidas INTEGER DEFAULT 0,
  aulas_utilizadas INTEGER DEFAULT 0,
  horas_quadra_incluidas INTEGER DEFAULT 0,
  horas_quadra_utilizadas INTEGER DEFAULT 0,

  -- Politicas
  politica_reposicao JSONB DEFAULT '{}',
  politica_cancelamento JSONB DEFAULT '{}',
  politica_desconto JSONB DEFAULT '{}',

  -- Pagamento
  forma_pagamento forma_pagamento NOT NULL,
  dados_pagamento JSONB,
  asaas_customer_id VARCHAR(50),

  -- Status
  status status_contrato NOT NULL DEFAULT 'ativo',
  motivo_cancelamento TEXT,
  data_cancelamento TIMESTAMPTZ,

  -- Observacoes
  observacoes TEXT,
  clausulas_especiais TEXT,

  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, numero_contrato),
  CHECK (data_fim > data_inicio),
  CHECK (valor_mensalidade > 0)
);

-- ============================================================
-- FATURAS (cobrancas geradas para clientes da arena)
-- Usa estrutura v2.0 com GENERATED columns + campos Asaas do v1.0
-- ============================================================
CREATE TABLE faturas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

  -- Dados da fatura
  numero_fatura VARCHAR(50) NOT NULL,
  competencia DATE NOT NULL,

  -- Datas importantes
  data_vencimento DATE NOT NULL,
  data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
  data_pagamento TIMESTAMPTZ,

  -- Valores
  valor_base DECIMAL(8,2) NOT NULL,
  desconto DECIMAL(8,2) DEFAULT 0,
  acrescimo DECIMAL(8,2) DEFAULT 0,
  valor_total DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_base - COALESCE(desconto, 0) + COALESCE(acrescimo, 0)
  ) STORED,
  valor_pago DECIMAL(8,2) DEFAULT 0,

  -- Status e forma de pagamento
  status status_fatura NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,

  -- Integracao Asaas
  asaas_payment_id VARCHAR(100),
  asaas_invoice_url TEXT,
  qr_code_pix TEXT,
  linha_digitavel TEXT,

  -- Observacoes
  observacoes TEXT,
  observacoes_internas TEXT,

  -- Historico de status
  historico_status JSONB DEFAULT '[]',

  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, numero_fatura),
  CHECK (valor_base > 0),
  CHECK (valor_pago >= 0)
);

-- ============================================================
-- COMISSOES DE PROFESSORES
-- ============================================================
CREATE TABLE comissoes_professores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  professor_id UUID REFERENCES professores(id) ON DELETE CASCADE,
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  periodo_inicio DATE NOT NULL,
  periodo_fim DATE NOT NULL,
  total_aulas INTEGER NOT NULL,
  valor_total_aulas DECIMAL(8,2) NOT NULL,
  percentual_comissao DECIMAL(5,2) NOT NULL,
  valor_comissao DECIMAL(8,2) NOT NULL,
  descontos DECIMAL(8,2) DEFAULT 0,
  valor_liquido DECIMAL(8,2) NOT NULL,
  data_pagamento DATE,
  forma_pagamento forma_pagamento,
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'calculada',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- DETALHES DAS COMISSOES (aulas individuais da comissao)
-- ============================================================
CREATE TABLE detalhes_comissoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  comissao_id UUID REFERENCES comissoes_professores(id) ON DELETE CASCADE,
  aula_id UUID REFERENCES aulas(id),
  data_aula DATE NOT NULL,
  valor_aula DECIMAL(8,2) NOT NULL,
  percentual_aplicado DECIMAL(5,2) NOT NULL,
  valor_comissao_aula DECIMAL(8,2) NOT NULL,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- MOVIMENTACOES FINANCEIRAS
-- Usa estrutura v2.0 expandida com conciliacao bancaria
-- ============================================================
CREATE TABLE movimentacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,

  -- Referencias
  fatura_id UUID REFERENCES faturas(id),
  agendamento_id UUID REFERENCES agendamentos(id),
  contrato_id UUID REFERENCES contratos(id),
  comissao_id UUID REFERENCES comissoes_professores(id),
  responsavel_id UUID REFERENCES usuarios(id),

  -- Dados da movimentacao
  tipo_movimentacao tipo_movimentacao NOT NULL,
  categoria categoria_financeira NOT NULL,
  subcategoria VARCHAR(100),

  -- Descricao e valores
  descricao VARCHAR(200) NOT NULL,
  observacoes TEXT,
  valor DECIMAL(10,2) NOT NULL,

  -- Data e forma de pagamento
  data_movimentacao DATE NOT NULL DEFAULT CURRENT_DATE,
  data_competencia DATE NOT NULL DEFAULT CURRENT_DATE,
  forma_pagamento forma_pagamento,

  -- Status
  confirmada BOOLEAN DEFAULT false,
  data_confirmacao TIMESTAMPTZ,

  -- Conciliacao bancaria
  conciliada BOOLEAN DEFAULT false,
  data_conciliacao DATE,
  conta_bancaria VARCHAR(100),

  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (valor != 0)
);

-- ============================================================
-- FORMAS DE PAGAMENTO (configuracao por arena)
-- ============================================================
CREATE TABLE formas_pagamento (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(50) NOT NULL,
  tipo forma_pagamento NOT NULL,
  taxa_fixa DECIMAL(8,2) DEFAULT 0,
  taxa_percentual DECIMAL(5,2) DEFAULT 0,
  prazo_recebimento INTEGER DEFAULT 0,
  ativa BOOLEAN NOT NULL DEFAULT true,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
