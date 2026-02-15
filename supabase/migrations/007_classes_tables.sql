-- ============================================================================
-- MIGRATION 007: Classes Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: tipos_aula, aulas, matriculas_aulas, reposicoes,
--         planos_aula, pacotes_aulas, compras_pacotes
-- Base: Legacy v1.0 (normalized - professor_id references professores)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- TIPOS DE AULA (catalogo de tipos de aula da arena)
-- ============================================================
CREATE TABLE tipos_aula (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(100) NOT NULL,
  modalidade tipo_esporte NOT NULL,
  nivel_exigido nivel_jogo NOT NULL,
  max_alunos INTEGER NOT NULL,
  duracao_minutos INTEGER NOT NULL,
  valor_aula DECIMAL(8,2) NOT NULL,
  descricao TEXT,
  equipamentos_necessarios JSONB DEFAULT '[]',
  status status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- AULAS (instancias de aulas agendadas)
-- Usa professores(id) como FK para garantir que so professores
-- podem ministrar aulas (pattern de extension table)
-- ============================================================
CREATE TABLE aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_aula_id UUID REFERENCES tipos_aula(id),
  professor_id UUID REFERENCES professores(id),          -- FK para professores, nao usuarios
  quadra_id UUID REFERENCES quadras(id),
  data_aula DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  max_alunos INTEGER NOT NULL,
  valor_total DECIMAL(8,2) NOT NULL,
  observacoes TEXT,
  material_aula TEXT,
  status status_aula NOT NULL DEFAULT 'agendada',        -- ENUM proprio de aula
  avaliacao_professor INTEGER CHECK (avaliacao_professor BETWEEN 1 AND 5),
  feedback_professor TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- MATRICULAS EM AULAS (alunos inscritos em aulas)
-- ============================================================
CREATE TABLE matriculas_aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  aula_id UUID REFERENCES aulas(id) ON DELETE CASCADE,
  aluno_id UUID REFERENCES usuarios(id),
  data_matricula TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valor_pago DECIMAL(8,2) NOT NULL,
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  presente BOOLEAN,
  data_checkin TIMESTAMPTZ,
  avaliacao_aula INTEGER CHECK (avaliacao_aula BETWEEN 1 AND 5),
  feedback_aluno TEXT,
  status status_matricula NOT NULL DEFAULT 'ativa',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- REPOSICOES (aulas de reposicao)
-- ============================================================
CREATE TABLE reposicoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  matricula_original_id UUID REFERENCES matriculas_aulas(id) ON DELETE CASCADE,
  aula_nova_id UUID REFERENCES aulas(id),
  motivo_reposicao motivo_reposicao NOT NULL,
  data_solicitacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  prazo_limite DATE NOT NULL,
  observacoes TEXT,
  status status_reposicao NOT NULL DEFAULT 'pendente',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PLANOS DE AULA (material didatico do professor)
-- ============================================================
CREATE TABLE planos_aula (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  professor_id UUID REFERENCES professores(id) ON DELETE CASCADE,
  tipo_aula_id UUID REFERENCES tipos_aula(id),
  titulo VARCHAR(150) NOT NULL,
  objetivos JSONB NOT NULL DEFAULT '[]',
  aquecimento TEXT,
  parte_principal TEXT NOT NULL,
  exercicios JSONB NOT NULL DEFAULT '[]',
  materiais_necessarios JSONB DEFAULT '[]',
  dificuldade nivel_jogo NOT NULL,
  duracao_estimada INTEGER NOT NULL,
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'rascunho',
  data_criacao DATE NOT NULL DEFAULT CURRENT_DATE,
  usado_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PACOTES DE AULAS (pacotes de aulas para venda)
-- ============================================================
CREATE TABLE pacotes_aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_pacote VARCHAR(100) NOT NULL,
  tipo_aula_id UUID REFERENCES tipos_aula(id),
  quantidade_aulas INTEGER NOT NULL,
  valor_total DECIMAL(8,2) NOT NULL,
  valor_por_aula DECIMAL(8,2) NOT NULL,
  desconto_percentual DECIMAL(5,2),
  validade_dias INTEGER NOT NULL,
  transferivel BOOLEAN NOT NULL DEFAULT false,
  reembolsavel BOOLEAN NOT NULL DEFAULT false,
  descricao TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- COMPRAS DE PACOTES (pacotes adquiridos por alunos)
-- //HIGH-RISK - transacao financeira
-- ============================================================
CREATE TABLE compras_pacotes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pacote_id UUID REFERENCES pacotes_aulas(id) ON DELETE CASCADE,
  aluno_id UUID REFERENCES usuarios(id),
  data_compra DATE NOT NULL DEFAULT CURRENT_DATE,
  data_vencimento DATE NOT NULL,
  aulas_restantes INTEGER NOT NULL,
  valor_pago DECIMAL(8,2) NOT NULL,
  forma_pagamento forma_pagamento NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
