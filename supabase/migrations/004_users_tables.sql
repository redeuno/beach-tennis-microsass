-- ============================================================================
-- MIGRATION 004: Users Tables
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Tables: usuarios, professores, funcionarios, permissoes
-- Base: Legacy v1.0 (normalized extension pattern)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- USUARIOS (tabela principal de todos os usuarios do sistema)
-- ============================================================
CREATE TABLE usuarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  auth_id UUID UNIQUE,                    -- ID do Supabase Auth
  tipo_usuario user_role NOT NULL,
  nome_completo VARCHAR(150) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefone VARCHAR(15) NOT NULL,
  whatsapp VARCHAR(15),
  cpf VARCHAR(14) NOT NULL,
  data_nascimento DATE NOT NULL,
  genero genero,
  endereco JSONB,
  nivel_jogo nivel_jogo,
  dominancia dominancia,
  posicao_preferida posicao_preferida,
  observacoes_medicas TEXT,
  contato_emergencia JSONB,
  foto_url TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
  ultimo_acesso TIMESTAMPTZ,
  aceite_termos BOOLEAN NOT NULL DEFAULT false,
  aceite_marketing BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, email),
  UNIQUE(arena_id, cpf)
);

-- ============================================================
-- PROFESSORES (extends usuarios - dados especificos de professor)
-- ============================================================
CREATE TABLE professores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  registro_profissional VARCHAR(50),
  especialidades JSONB NOT NULL DEFAULT '[]',
  valor_hora_aula DECIMAL(8,2) NOT NULL,
  percentual_comissao DECIMAL(5,2),
  disponibilidade JSONB NOT NULL DEFAULT '{}',
  biografia TEXT,
  certificacoes JSONB DEFAULT '[]',
  experiencia_anos INTEGER,
  status_professor status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- FUNCIONARIOS (extends usuarios - dados especificos de funcionario)
-- //HIGH-RISK - contém dados salariais
-- ============================================================
CREATE TABLE funcionarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  cargo VARCHAR(50) NOT NULL,
  salario DECIMAL(8,2),
  permissoes JSONB NOT NULL DEFAULT '[]',
  horario_trabalho JSONB NOT NULL DEFAULT '{}',
  data_admissao DATE NOT NULL,
  data_demissao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- PERMISSOES (controle granular de permissoes por usuario)
-- ============================================================
CREATE TABLE permissoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  modulo VARCHAR(50) NOT NULL,
  acao VARCHAR(20) NOT NULL,
  permitido BOOLEAN NOT NULL DEFAULT false,
  data_concessao DATE NOT NULL DEFAULT CURRENT_DATE,
  concedida_por UUID REFERENCES usuarios(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(usuario_id, modulo, acao)
);
