# Schemas SQL - Banco de Dados

[<- Voltar ao Indice](../README.md) | [Seguranca e RLS](./rls-and-security.md)

---

## Visao Geral

- **Engine:** PostgreSQL (Supabase)
- **Isolamento:** Multi-tenant via `arena_id` + RLS
- **Extensoes:** uuid-ossp, pgcrypto, postgis
- **Timezone:** America/Sao_Paulo

---

## Configuracoes Iniciais

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "postgis";

SET timezone = 'America/Sao_Paulo';
ALTER DATABASE postgres SET row_security = on;
```

---

## Tipos Personalizados (ENUMs)

```sql
-- Roles de usuario
CREATE TYPE user_role AS ENUM (
  'super_admin', 'arena_admin', 'funcionario', 'professor', 'aluno'
);

-- Status gerais
CREATE TYPE status_geral AS ENUM ('ativo', 'inativo', 'suspenso', 'bloqueado');

-- Esportes e infraestrutura
CREATE TYPE tipo_esporte AS ENUM ('beach_tennis', 'padel', 'tenis', 'futevolei');
CREATE TYPE tipo_piso AS ENUM ('areia', 'saibro', 'sintetico', 'concreto', 'grama');

-- Agendamentos
CREATE TYPE status_agendamento AS ENUM ('confirmado', 'pendente', 'cancelado', 'realizado', 'no_show');
CREATE TYPE tipo_agendamento AS ENUM ('avulso', 'aula', 'torneio', 'evento', 'manutencao', 'bloqueio');

-- Check-in
CREATE TYPE tipo_checkin AS ENUM ('qrcode', 'geolocalizacao', 'manual', 'biometria', 'facial');
CREATE TYPE status_checkin AS ENUM ('presente', 'ausente', 'atrasado', 'cancelado');

-- Financeiro
CREATE TYPE status_pagamento AS ENUM ('pendente', 'pago', 'parcial', 'cancelado', 'vencido', 'estornado');
CREATE TYPE forma_pagamento AS ENUM ('pix', 'cartao_credito', 'cartao_debito', 'dinheiro', 'boleto', 'credito', 'transferencia');
CREATE TYPE tipo_plano AS ENUM ('mensal', 'trimestral', 'semestral', 'anual', 'avulso');
CREATE TYPE status_contrato AS ENUM ('ativo', 'suspenso', 'cancelado', 'inadimplente', 'pausado');
CREATE TYPE status_fatura AS ENUM ('pendente', 'paga', 'vencida', 'cancelada', 'parcial');
CREATE TYPE tipo_movimentacao AS ENUM ('receita', 'despesa', 'transferencia', 'estorno');
CREATE TYPE categoria_financeira AS ENUM (
  'mensalidade', 'aula_avulsa', 'aluguel_quadra', 'torneio', 'evento',
  'produto', 'multa', 'taxa', 'desconto', 'promocao',
  'manutencao', 'equipamento', 'funcionario', 'marketing', 'outros'
);

-- Perfil do jogador
CREATE TYPE nivel_jogo AS ENUM ('iniciante', 'intermediario', 'intermediario_avancado', 'avancado', 'profissional');
CREATE TYPE genero AS ENUM ('masculino', 'feminino', 'outro', 'nao_informado');
CREATE TYPE dominancia AS ENUM ('destro', 'canhoto', 'ambidestro');
CREATE TYPE posicao_preferida AS ENUM ('rede', 'fundo', 'ambas', 'especialista_rede', 'especialista_fundo');

-- Eventos e torneios
CREATE TYPE tipo_evento AS ENUM ('workshop', 'clinica', 'festa', 'campeonato', 'promocional', 'corporativo');
CREATE TYPE status_evento AS ENUM ('planejado', 'divulgado', 'aberto', 'realizado', 'cancelado');
CREATE TYPE status_inscricao AS ENUM ('inscrito', 'confirmado', 'cancelado', 'lista_espera', 'presente', 'ausente');

-- Sistema
CREATE TYPE categoria_config AS ENUM (
  'geral', 'financeiro', 'agendamento', 'comunicacao', 'integracao',
  'relatorio', 'seguranca', 'personalizacao', 'automacao'
);
CREATE TYPE tipo_relatorio AS ENUM ('operacional', 'financeiro', 'marketing', 'performance', 'administrativo');
CREATE TYPE nivel_acesso_relatorio AS ENUM ('publico', 'professor', 'funcionario', 'admin', 'super_admin');
CREATE TYPE status_modulo AS ENUM ('ativo', 'inativo', 'beta', 'deprecated');
CREATE TYPE tipo_modulo AS ENUM ('core', 'financeiro', 'comunicacao', 'relatorios', 'integracao', 'premium');
```

---

## Tabelas - Plataforma (Super Admin)

### planos_sistema
```sql
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
```

### modulos_sistema
```sql
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
```

### arena_modulos
```sql
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
```

---

## Tabelas - Arenas e Usuarios

### arenas
```sql
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
```

### arenas_planos
```sql
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
```

### usuarios
```sql
CREATE TABLE usuarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  auth_id UUID UNIQUE,
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
```

### professores
```sql
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
```

### funcionarios
```sql
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
```

---

## Tabelas - Quadras e Infraestrutura

### quadras
```sql
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
  status VARCHAR(20) NOT NULL DEFAULT 'ativa',
  ultima_manutencao DATE,
  proxima_manutencao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### quadras_bloqueios
```sql
CREATE TABLE quadras_bloqueios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_bloqueio VARCHAR(20) NOT NULL,
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  responsavel_id UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### manutencoes
```sql
CREATE TABLE manutencoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_manutencao VARCHAR(20) NOT NULL,
  data_manutencao DATE NOT NULL,
  descricao TEXT NOT NULL,
  fornecedor VARCHAR(100),
  valor_gasto DECIMAL(8,2),
  tempo_parada INTEGER,
  responsavel_id UUID REFERENCES usuarios(id),
  proximo_agendamento DATE,
  anexos JSONB DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'concluida',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## Tabelas - Agendamentos e Check-in

### agendamentos
```sql
CREATE TABLE agendamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  criado_por_id UUID REFERENCES usuarios(id),
  cliente_principal_id UUID REFERENCES usuarios(id),

  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  duracao_minutos INTEGER GENERATED ALWAYS AS (
    EXTRACT(EPOCH FROM (hora_fim - hora_inicio)) / 60
  ) STORED,

  tipo tipo_agendamento NOT NULL DEFAULT 'avulso',
  modalidade tipo_esporte NOT NULL,

  participantes JSONB DEFAULT '[]',
  max_participantes INTEGER DEFAULT 4,
  lista_espera JSONB DEFAULT '[]',

  valor_total DECIMAL(8,2) NOT NULL DEFAULT 0,
  valor_por_pessoa DECIMAL(8,2),
  desconto_aplicado DECIMAL(8,2) DEFAULT 0,
  valor_final DECIMAL(8,2) GENERATED ALWAYS AS (valor_total - COALESCE(desconto_aplicado, 0)) STORED,

  status status_agendamento NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  observacoes_internas TEXT,

  e_recorrente BOOLEAN DEFAULT false,
  recorrencia_config JSONB DEFAULT '{}',
  agendamento_pai_id UUID REFERENCES agendamentos(id),

  permite_checkin BOOLEAN DEFAULT true,
  checkin_aberto_em TIMESTAMPTZ,
  checkin_fechado_em TIMESTAMPTZ,
  checkins JSONB DEFAULT '[]',

  notificacoes_enviadas JSONB DEFAULT '[]',
  lembrete_enviado BOOLEAN DEFAULT false,

  data_cancelamento TIMESTAMPTZ,
  motivo_cancelamento TEXT,
  cancelado_por_id UUID REFERENCES usuarios(id),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (hora_fim > hora_inicio),
  CHECK (valor_total >= 0),
  CHECK (max_participantes > 0)
);
```

### checkins
```sql
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
```

### lista_espera
```sql
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
```

---

## Tabelas - Aulas

### aulas
```sql
CREATE TABLE aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE CASCADE,
  professor_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,

  nome VARCHAR(150),
  tipo_aula VARCHAR(50) NOT NULL,
  modalidade tipo_esporte NOT NULL,
  nivel_aula nivel_jogo,

  alunos JSONB DEFAULT '[]',
  max_alunos INTEGER DEFAULT 4,
  min_alunos INTEGER DEFAULT 1,

  objetivos TEXT,
  conteudo_programatico TEXT,
  material_necessario JSONB DEFAULT '[]',

  valor_aula DECIMAL(8,2) NOT NULL,
  duracao_minutos INTEGER NOT NULL DEFAULT 60,

  checkin_habilitado BOOLEAN DEFAULT true,
  checkin_config JSONB DEFAULT '{}',
  presencas JSONB DEFAULT '[]',

  avaliacao_professor JSONB DEFAULT '{}',
  feedback_alunos JSONB DEFAULT '[]',
  notas_professor TEXT,

  e_reposicao BOOLEAN DEFAULT false,
  aula_original_id UUID REFERENCES aulas(id),
  motivo_reposicao TEXT,

  status status_agendamento NOT NULL DEFAULT 'confirmado',
  realizada BOOLEAN DEFAULT false,
  data_realizacao TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (max_alunos >= min_alunos),
  CHECK (valor_aula >= 0)
);
```

### tipos_aula
```sql
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
```

### pacotes_aulas
```sql
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
```

---

## Tabelas - Financeiro

### contratos
```sql
CREATE TABLE contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  vendedor_id UUID REFERENCES usuarios(id),

  numero_contrato VARCHAR(50) NOT NULL,
  tipo_plano tipo_plano NOT NULL,
  modalidade tipo_esporte NOT NULL,

  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_vencimento_mensalidade INTEGER NOT NULL DEFAULT 10,

  valor_mensalidade DECIMAL(8,2) NOT NULL,
  valor_taxa_adesao DECIMAL(8,2) DEFAULT 0,
  desconto_percentual DECIMAL(5,2) DEFAULT 0,
  valor_desconto DECIMAL(8,2) DEFAULT 0,
  valor_final_mensalidade DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_mensalidade - COALESCE(valor_desconto, 0) - (valor_mensalidade * COALESCE(desconto_percentual, 0) / 100)
  ) STORED,

  aulas_incluidas INTEGER DEFAULT 0,
  aulas_utilizadas INTEGER DEFAULT 0,
  horas_quadra_incluidas INTEGER DEFAULT 0,
  horas_quadra_utilizadas INTEGER DEFAULT 0,

  politica_reposicao JSONB DEFAULT '{}',
  politica_cancelamento JSONB DEFAULT '{}',
  politica_desconto JSONB DEFAULT '{}',

  status status_contrato NOT NULL DEFAULT 'ativo',
  motivo_cancelamento TEXT,
  data_cancelamento TIMESTAMPTZ,

  observacoes TEXT,
  clausulas_especiais TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, numero_contrato),
  CHECK (data_fim > data_inicio),
  CHECK (valor_mensalidade > 0)
);
```

### faturas
```sql
CREATE TABLE faturas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

  numero_fatura VARCHAR(50) NOT NULL,
  competencia DATE NOT NULL,

  data_vencimento DATE NOT NULL,
  data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
  data_pagamento TIMESTAMPTZ,

  valor_base DECIMAL(8,2) NOT NULL,
  desconto DECIMAL(8,2) DEFAULT 0,
  acrescimo DECIMAL(8,2) DEFAULT 0,
  valor_total DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_base - COALESCE(desconto, 0) + COALESCE(acrescimo, 0)
  ) STORED,
  valor_pago DECIMAL(8,2) DEFAULT 0,

  status status_fatura NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,

  asaas_payment_id VARCHAR(100),
  asaas_invoice_url TEXT,
  qr_code_pix TEXT,
  linha_digitavel TEXT,

  observacoes TEXT,
  observacoes_internas TEXT,
  historico_status JSONB DEFAULT '[]',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(arena_id, numero_fatura),
  CHECK (valor_base > 0),
  CHECK (valor_pago >= 0)
);
```

### movimentacoes_financeiras
```sql
CREATE TABLE movimentacoes_financeiras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,

  fatura_id UUID REFERENCES faturas(id),
  agendamento_id UUID REFERENCES agendamentos(id),
  contrato_id UUID REFERENCES contratos(id),
  usuario_responsavel_id UUID REFERENCES usuarios(id),

  tipo tipo_movimentacao NOT NULL,
  categoria categoria_financeira NOT NULL,
  subcategoria VARCHAR(100),

  descricao VARCHAR(200) NOT NULL,
  observacoes TEXT,
  valor DECIMAL(10,2) NOT NULL,

  data_movimentacao DATE NOT NULL DEFAULT CURRENT_DATE,
  data_competencia DATE NOT NULL DEFAULT CURRENT_DATE,
  forma_pagamento forma_pagamento,

  confirmada BOOLEAN DEFAULT false,
  data_confirmacao TIMESTAMPTZ,

  conciliada BOOLEAN DEFAULT false,
  data_conciliacao DATE,
  conta_bancaria VARCHAR(100),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (valor != 0)
);
```

---

## Tabelas - Torneios e Eventos

### torneios
```sql
CREATE TABLE torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  criado_por_id UUID REFERENCES usuarios(id),

  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  modalidade tipo_esporte NOT NULL,

  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_limite_inscricao TIMESTAMPTZ NOT NULL,

  max_participantes INTEGER,
  max_duplas INTEGER,
  formato_chaveamento VARCHAR(50) DEFAULT 'eliminacao_simples',
  categoria_nivel nivel_jogo,
  categoria_idade_min INTEGER,
  categoria_idade_max INTEGER,
  categoria_genero genero,

  taxa_inscricao DECIMAL(8,2) NOT NULL DEFAULT 0,
  premiacao_total DECIMAL(8,2) DEFAULT 0,
  distribuicao_premiacao JSONB DEFAULT '{}',

  quadras_utilizadas JSONB DEFAULT '[]',
  cronograma JSONB DEFAULT '{}',

  status status_evento NOT NULL DEFAULT 'planejado',

  regulamento TEXT,
  regras_especiais TEXT,
  material_incluido JSONB DEFAULT '[]',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CHECK (data_fim >= data_inicio),
  CHECK (data_limite_inscricao <= data_inicio),
  CHECK (taxa_inscricao >= 0)
);
```

### inscricoes_torneios
```sql
CREATE TABLE inscricoes_torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,

  jogador1_id UUID REFERENCES usuarios(id) NOT NULL,
  jogador2_id UUID REFERENCES usuarios(id),

  data_inscricao TIMESTAMPTZ DEFAULT NOW(),
  valor_pago DECIMAL(8,2) DEFAULT 0,
  forma_pagamento forma_pagamento,

  status status_inscricao NOT NULL DEFAULT 'inscrito',
  posicao_chaveamento INTEGER,

  documentos_enviados JSONB DEFAULT '[]',
  documentos_aprovados BOOLEAN DEFAULT false,

  observacoes TEXT,
  necessidades_especiais TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(torneio_id, jogador1_id, jogador2_id)
);
```

### eventos
```sql
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
```

---

## Tabelas - Configuracao e Auditoria

### configuracoes_arena
```sql
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
```

### politicas_negocio
```sql
CREATE TABLE politicas_negocio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_politica VARCHAR(50) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  regras JSONB NOT NULL DEFAULT '{}',
  descricao TEXT NOT NULL,
  ativa BOOLEAN NOT NULL DEFAULT true,
  data_vigencia DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### historico_atividades
```sql
CREATE TABLE historico_atividades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_atividade VARCHAR(50) NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  detalhes JSONB DEFAULT '{}',
  data_atividade TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### auditoria
```sql
CREATE TABLE auditoria (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tabela VARCHAR(100) NOT NULL,
  operacao VARCHAR(10) NOT NULL,
  registro_id UUID NOT NULL,
  usuario_id UUID REFERENCES usuarios(id),
  arena_id UUID REFERENCES arenas(id),
  dados_anteriores JSONB,
  dados_novos JSONB,
  timestamp_operacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT
);
```

### relatorios_sistema
```sql
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
```

### arena_relatorios_config
```sql
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
```

---

## Mapa de Relacionamentos

```
planos_sistema ──┐
                 ├── arenas ──┬── usuarios ──┬── professores
modulos_sistema ─┘            │              ├── funcionarios
                              ├── quadras ───┬── quadras_bloqueios
                              │              └── manutencoes
                              ├── agendamentos ── checkins
                              │              └── lista_espera
                              ├── aulas ──── tipos_aula
                              │              └── pacotes_aulas
                              ├── contratos ── faturas
                              │              └── movimentacoes_financeiras
                              ├── torneios ── inscricoes_torneios
                              │              └── eventos
                              ├── configuracoes_arena
                              ├── politicas_negocio
                              ├── historico_atividades
                              └── auditoria
```

---

**Proximos:** [Seguranca e RLS](./rls-and-security.md) | [Modulos](../modules/)
