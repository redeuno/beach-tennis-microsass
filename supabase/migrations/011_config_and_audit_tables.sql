-- ============================================================================
-- MIGRATION 011: Configuration, Audit and Management Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: configuracoes_arena, politicas_negocio, modulos_arena,
--         sessoes_usuario, historico_atividades, avaliacoes_performance,
--         evolucao_alunos, relatorios_personalizados,
--         configuracoes_visibilidade, logs_sistema, auditoria_dados,
--         configuracoes
-- Base: Legacy v1.0 (todas tabelas presentes)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- CONFIGURACOES DA ARENA (chave-valor por categoria)
-- ============================================================
CREATE TABLE configuracoes_arena (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  categoria categoria_config NOT NULL,
  chave VARCHAR(100) NOT NULL,
  valor JSONB NOT NULL,
  descricao TEXT,
  editavel BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, chave)
);

-- ============================================================
-- POLITICAS DE NEGOCIO
-- ============================================================
CREATE TABLE politicas_negocio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_politica VARCHAR(50) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  regras JSONB NOT NULL,
  descricao TEXT NOT NULL,
  ativa BOOLEAN NOT NULL DEFAULT true,
  data_vigencia DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- MODULOS POR ARENA (controle legado de ativacao de modulos)
-- Complementa arena_modulos (003) com dados de auditoria
-- ============================================================
CREATE TABLE modulos_arena (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  modulo_nome VARCHAR(50) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true,
  data_ativacao DATE,
  data_desativacao DATE,
  motivo_desativacao TEXT,
  configurado_por UUID REFERENCES usuarios(id),
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, modulo_nome)
);

-- ============================================================
-- SESSOES DE USUARIO (rastreamento de sessoes ativas)
-- ============================================================
CREATE TABLE sessoes_usuario (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  token_sessao VARCHAR(255) NOT NULL UNIQUE,
  ip_address INET NOT NULL,
  user_agent TEXT NOT NULL,
  data_login TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_ultima_atividade TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_expiracao TIMESTAMPTZ NOT NULL,
  ativa BOOLEAN NOT NULL DEFAULT true,
  tipo_dispositivo VARCHAR(20) NOT NULL DEFAULT 'web',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- HISTORICO DE ATIVIDADES (log de acoes do usuario)
-- ============================================================
CREATE TABLE historico_atividades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_atividade VARCHAR(50) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  detalhes JSONB,
  data_atividade TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- AVALIACOES DE PERFORMANCE
-- ============================================================
CREATE TABLE avaliacoes_performance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_avaliado_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  avaliador_id UUID REFERENCES usuarios(id),
  tipo_avaliacao VARCHAR(20) NOT NULL,
  periodo_inicio DATE NOT NULL,
  periodo_fim DATE NOT NULL,
  criterios_avaliacao JSONB NOT NULL,
  nota_geral DECIMAL(3,2) NOT NULL CHECK (nota_geral BETWEEN 0 AND 10),
  pontos_fortes TEXT,
  pontos_melhorar TEXT,
  metas_futuras TEXT,
  visivel_avaliado BOOLEAN NOT NULL DEFAULT true,
  data_avaliacao DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- EVOLUCAO DOS ALUNOS (tracking de progresso)
-- ============================================================
CREATE TABLE evolucao_alunos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  aluno_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  professor_id UUID REFERENCES professores(id),
  data_avaliacao DATE NOT NULL DEFAULT CURRENT_DATE,
  nivel_anterior nivel_jogo,
  nivel_atual nivel_jogo NOT NULL,
  habilidades_desenvolvidas JSONB NOT NULL DEFAULT '[]',
  areas_melhorar JSONB DEFAULT '[]',
  observacoes TEXT,
  proximos_objetivos TEXT,
  visivel_aluno BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- RELATORIOS PERSONALIZADOS
-- ============================================================
CREATE TABLE relatorios_personalizados (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_relatorio VARCHAR(100) NOT NULL,
  tipo_relatorio VARCHAR(50) NOT NULL,
  filtros JSONB NOT NULL DEFAULT '{}',
  colunas_visiveis JSONB NOT NULL DEFAULT '[]',
  periodo_padrao VARCHAR(20) NOT NULL DEFAULT 'mes',
  frequencia_envio VARCHAR(20),
  emails_destinatarios JSONB DEFAULT '[]',
  visivel_para JSONB NOT NULL DEFAULT '[]',
  criado_por UUID REFERENCES usuarios(id),
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- CONFIGURACOES DE VISIBILIDADE (por tipo de usuario e secao)
-- ============================================================
CREATE TABLE configuracoes_visibilidade (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_usuario user_role NOT NULL,
  secao_relatorio VARCHAR(50) NOT NULL,
  visivel BOOLEAN NOT NULL DEFAULT false,
  nivel_detalhe VARCHAR(20) NOT NULL DEFAULT 'basico',
  campos_bloqueados JSONB DEFAULT '[]',
  observacoes TEXT,
  configurado_por UUID REFERENCES usuarios(id),
  data_configuracao DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, tipo_usuario, secao_relatorio)
);

-- ============================================================
-- LOGS DO SISTEMA
-- ============================================================
CREATE TABLE logs_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  acao VARCHAR(100) NOT NULL,
  modulo VARCHAR(50) NOT NULL,
  tabela_afetada VARCHAR(50),
  registro_id UUID,
  valores_anteriores JSONB,
  valores_novos JSONB,
  ip_address INET,
  user_agent TEXT,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  nivel_log nivel_log NOT NULL DEFAULT 'info'
);

-- ============================================================
-- AUDITORIA DE DADOS (log completo de mudancas)
-- //HIGH-RISK - dados sensiveis de auditoria
-- ============================================================
CREATE TABLE auditoria_dados (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tabela VARCHAR(50) NOT NULL,
  operacao operacao_auditoria NOT NULL,
  registro_id UUID NOT NULL,
  usuario_responsavel UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  dados_anteriores JSONB,
  dados_novos JSONB NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  origem origem_operacao NOT NULL DEFAULT 'web'
);

-- ============================================================
-- CONFIGURACOES GERAIS (sistema)
-- ============================================================
CREATE TABLE configuracoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  categoria categoria_config NOT NULL,
  chave VARCHAR(100) NOT NULL,
  valor JSONB NOT NULL,
  tipo_campo tipo_campo NOT NULL,
  descricao TEXT,
  editavel BOOLEAN NOT NULL DEFAULT true,
  visivel_admin BOOLEAN NOT NULL DEFAULT true,
  updated_by UUID REFERENCES usuarios(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, chave)
);
