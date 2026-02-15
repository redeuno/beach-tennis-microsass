-- ============================================================================
-- MIGRATION 009: Tournaments and Events Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: torneios, inscricoes_torneios, chaveamento, partidas_torneio,
--         resultados_torneio, eventos, participantes_eventos
-- Base: Legacy v1.0 (todas tabelas presentes) + v2.0 campos extras
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- TORNEIOS
-- Merge: v2.0 campos expandidos + v1.0 ENUMs proprios
-- ============================================================
CREATE TABLE torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  criado_por_id UUID REFERENCES usuarios(id),

  -- Dados basicos
  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  modalidade tipo_esporte NOT NULL,
  categoria categoria_torneio NOT NULL,       -- ENUM proprio de torneio
  tipo_disputa tipo_disputa NOT NULL,

  -- Datas importantes
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_limite_inscricao TIMESTAMPTZ NOT NULL,

  -- Configuracoes
  max_participantes INTEGER NOT NULL,
  max_duplas INTEGER,
  formato_chaveamento VARCHAR(50) DEFAULT 'eliminacao_simples',
  categoria_nivel nivel_jogo,
  categoria_idade_min INTEGER,
  categoria_idade_max INTEGER,
  categoria_genero genero,

  -- Valores
  valor_inscricao DECIMAL(8,2) NOT NULL DEFAULT 0,
  premiacao_total DECIMAL(8,2) DEFAULT 0,
  premiacao JSONB,
  distribuicao_premiacao JSONB DEFAULT '{}',

  -- Quadras e horarios
  quadras_utilizadas JSONB DEFAULT '[]',
  cronograma JSONB DEFAULT '{}',

  -- Regulamento
  regulamento TEXT NOT NULL,
  regras_especiais TEXT,
  material_incluido JSONB DEFAULT '[]',
  observacoes TEXT,

  -- Status
  status status_torneio NOT NULL DEFAULT 'inscricoes_abertas',

  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (data_fim >= data_inicio),
  CHECK (valor_inscricao >= 0)
);

-- ============================================================
-- INSCRICOES EM TORNEIOS
-- ============================================================
CREATE TABLE inscricoes_torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  jogador1_id UUID REFERENCES usuarios(id) NOT NULL,
  jogador2_id UUID REFERENCES usuarios(id),
  data_inscricao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valor_pago DECIMAL(8,2) NOT NULL DEFAULT 0,
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,
  posicao_chaveamento INTEGER,

  -- Documentacao (v2.0)
  documentos_enviados JSONB DEFAULT '[]',
  documentos_aprovados BOOLEAN DEFAULT false,

  -- Observacoes
  observacoes TEXT,
  necessidades_especiais TEXT,

  -- Status
  status status_inscricao NOT NULL DEFAULT 'pendente',

  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(torneio_id, jogador1_id, jogador2_id)
);

-- ============================================================
-- CHAVEAMENTO (estrutura de chaves do torneio)
-- Tabela presente APENAS no v1.0 - restaurada
-- ============================================================
CREATE TABLE chaveamento (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  tipo_chave tipo_chave NOT NULL,
  estrutura_chave JSONB NOT NULL,
  data_sorteio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  criterio_sorteio criterio_sorteio NOT NULL,
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'gerada',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PARTIDAS DO TORNEIO (jogos individuais)
-- Tabela presente APENAS no v1.0 - restaurada
-- ============================================================
CREATE TABLE partidas_torneio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  chaveamento_id UUID REFERENCES chaveamento(id),
  fase fase_torneio NOT NULL,
  rodada INTEGER NOT NULL,
  inscricao1_id UUID REFERENCES inscricoes_torneios(id),
  inscricao2_id UUID REFERENCES inscricoes_torneios(id),
  quadra_id UUID REFERENCES quadras(id),
  data_agendada TIMESTAMPTZ,
  data_realizada TIMESTAMPTZ,
  placar JSONB,
  inscricao_vencedora_id UUID REFERENCES inscricoes_torneios(id),
  observacoes TEXT,
  status status_partida NOT NULL DEFAULT 'agendada',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- RESULTADOS E RANKINGS DO TORNEIO
-- Tabela presente APENAS no v1.0 - restaurada
-- ============================================================
CREATE TABLE resultados_torneio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  inscricao_id UUID REFERENCES inscricoes_torneios(id),
  posicao_final INTEGER NOT NULL,
  pontos_conquistados INTEGER DEFAULT 0,
  premiacao_recebida DECIMAL(8,2) DEFAULT 0,
  partidas_jogadas INTEGER NOT NULL,
  vitorias INTEGER NOT NULL,
  derrotas INTEGER NOT NULL,
  sets_vencidos INTEGER DEFAULT 0,
  sets_perdidos INTEGER DEFAULT 0,
  games_vencidos INTEGER DEFAULT 0,
  games_perdidos INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- EVENTOS ESPECIAIS (clinicas, workshops, confraternizacoes)
-- ============================================================
CREATE TABLE eventos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_evento VARCHAR(150) NOT NULL,
  tipo_evento tipo_evento NOT NULL,
  data_evento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  max_participantes INTEGER,
  valor_inscricao DECIMAL(8,2),
  descricao TEXT NOT NULL,
  material_incluso JSONB DEFAULT '[]',
  responsavel_id UUID REFERENCES usuarios(id),
  quadras_utilizadas JSONB DEFAULT '[]',
  status status_evento NOT NULL DEFAULT 'planejado',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PARTICIPANTES DE EVENTOS
-- Tabela presente APENAS no v1.0 - restaurada
-- ============================================================
CREATE TABLE participantes_eventos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  evento_id UUID REFERENCES eventos(id) ON DELETE CASCADE,
  participante_id UUID REFERENCES usuarios(id),
  data_inscricao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valor_pago DECIMAL(8,2),
  presente BOOLEAN,
  avaliacao INTEGER CHECK (avaliacao BETWEEN 1 AND 5),
  feedback TEXT,
  status status_inscricao NOT NULL DEFAULT 'inscrito',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
