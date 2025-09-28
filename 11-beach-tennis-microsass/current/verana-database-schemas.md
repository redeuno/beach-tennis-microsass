# VERANA BEACH TENNIS - DATABASE SCHEMAS COMPLETOS
## Estruturas SQL do Supabase - Versão Consolidada

**Versão: 1.0**  
**Data: 28/09/2025**  
**Base:** Consolidação dos schemas v1.0 + v2.0  
**Database:** PostgreSQL (Supabase)  
**Recursos:** RLS + Multi-tenant + Módulos Configuráveis

---

## VISÃO GERAL DO BANCO DE DADOS

### **Características Principais:**
- **Multi-tenant**: Isolamento completo por arena
- **Row Level Security (RLS)**: Segurança nativa do PostgreSQL
- **Módulos Configuráveis**: Ativação/desativação por plano
- **Relatórios Flexíveis**: Configuração de visibilidade por perfil
- **Auditoria Completa**: Logs de todas as operações

### **Estrutura Organizacional:**
1. **Configurações Iniciais** - Extensões e timezone
2. **Tipos Personalizados** - ENUMs para padronização
3. **Controle de Módulos** - Sistema de permissões granular
4. **Tabelas Principais** - Entidades core do sistema
5. **Tabelas de Gestão** - Configurações e políticas
6. **Políticas RLS** - Segurança multi-tenant
7. **Triggers e Funções** - Automações do banco

---

## SEÇÃO 1: EXTENSÕES E CONFIGURAÇÕES INICIAIS

```sql
-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Configurar timezone padrão
SET timezone = 'America/Sao_Paulo';

-- Habilitar RLS globalmente
ALTER DATABASE postgres SET row_security = on;
```

---

## SEÇÃO 2: TIPOS PERSONALIZADOS (ENUMS)

```sql
-- Tipos de usuário
CREATE TYPE user_role AS ENUM (
  'super_admin',
  'arena_admin', 
  'funcionario',
  'professor',
  'aluno'
);

-- Status gerais
CREATE TYPE status_geral AS ENUM ('ativo', 'inativo', 'suspenso', 'bloqueado');

-- Tipos de esporte
CREATE TYPE tipo_esporte AS ENUM ('beach_tennis', 'padel', 'tenis', 'futevolei');

-- Tipos de piso
CREATE TYPE tipo_piso AS ENUM ('areia', 'saibro', 'sintetico', 'concreto', 'grama');

-- Status de agendamento
CREATE TYPE status_agendamento AS ENUM ('confirmado', 'pendente', 'cancelado', 'realizado', 'no_show');

-- Status de pagamento
CREATE TYPE status_pagamento AS ENUM ('pendente', 'pago', 'parcial', 'cancelado', 'vencido', 'estornado');

-- Formas de pagamento
CREATE TYPE forma_pagamento AS ENUM ('pix', 'cartao_credito', 'cartao_debito', 'dinheiro', 'boleto', 'credito', 'transferencia');

-- Tipos de agendamento
CREATE TYPE tipo_agendamento AS ENUM ('avulso', 'aula', 'torneio', 'evento', 'manutencao', 'bloqueio');

-- Tipos de check-in
CREATE TYPE tipo_checkin AS ENUM ('qrcode', 'geolocalizacao', 'manual', 'biometria', 'facial');

-- Status de check-in
CREATE TYPE status_checkin AS ENUM ('presente', 'ausente', 'atrasado', 'cancelado');

-- Níveis de jogo
CREATE TYPE nivel_jogo AS ENUM ('iniciante', 'intermediario', 'intermediario_avancado', 'avancado', 'profissional');

-- Gêneros
CREATE TYPE genero AS ENUM ('masculino', 'feminino', 'outro', 'nao_informado');

-- Dominância
CREATE TYPE dominancia AS ENUM ('destro', 'canhoto', 'ambidestro');

-- Posição preferida
CREATE TYPE posicao_preferida AS ENUM ('rede', 'fundo', 'ambas', 'especialista_rede', 'especialista_fundo');

-- Tipos de plano
CREATE TYPE tipo_plano AS ENUM ('mensal', 'trimestral', 'semestral', 'anual', 'avulso');

-- Status de contrato
CREATE TYPE status_contrato AS ENUM ('ativo', 'suspenso', 'cancelado', 'inadimplente', 'pausado');

-- Status de fatura
CREATE TYPE status_fatura AS ENUM ('pendente', 'paga', 'vencida', 'cancelada', 'parcial');

-- Tipos de movimentação financeira
CREATE TYPE tipo_movimentacao AS ENUM ('receita', 'despesa', 'transferencia', 'estorno');

-- Categorias financeiras
CREATE TYPE categoria_financeira AS ENUM (
  'mensalidade', 'aula_avulsa', 'aluguel_quadra', 'torneio', 'evento',
  'produto', 'multa', 'taxa', 'desconto', 'promocao',
  'manutencao', 'equipamento', 'funcionario', 'marketing', 'outros'
);

-- Tipos de evento
CREATE TYPE tipo_evento AS ENUM ('workshop', 'clinica', 'festa', 'campeonato', 'promocional', 'corporativo');

-- Status de evento
CREATE TYPE status_evento AS ENUM ('planejado', 'divulgado', 'aberto', 'realizado', 'cancelado');

-- Status de inscrição
CREATE TYPE status_inscricao AS ENUM ('inscrito', 'confirmado', 'cancelado', 'lista_espera', 'presente', 'ausente');

-- Categorias de configuração
CREATE TYPE categoria_config AS ENUM (
  'geral', 'financeiro', 'agendamento', 'comunicacao', 'integracao', 
  'relatorio', 'seguranca', 'personalizacao', 'automacao'
);

-- Tipos de relatório
CREATE TYPE tipo_relatorio AS ENUM (
  'operacional', 'financeiro', 'marketing', 'performance', 'administrativo'
);

-- Níveis de acesso a relatórios
CREATE TYPE nivel_acesso_relatorio AS ENUM (
  'publico', 'professor', 'funcionario', 'admin', 'super_admin'
);

-- Status de módulo
CREATE TYPE status_modulo AS ENUM ('ativo', 'inativo', 'beta', 'deprecated');

-- Tipos de módulo
CREATE TYPE tipo_modulo AS ENUM (
  'core', 'financeiro', 'comunicacao', 'relatorios', 'integracao', 'premium'
);
```

---

## SEÇÃO 3: CONTROLE DE MÓDULOS E PERMISSÕES

```sql
-- Tabela de planos do sistema (Super Admin)
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

-- Tabela de módulos do sistema
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

-- Tabela de módulos liberados por arena
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

-- Tabela de relatórios disponíveis
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

-- Tabela de configuração de visibilidade de relatórios por arena
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

## SEÇÃO 4: TABELAS PRINCIPAIS

### **Arenas e Usuários**

```sql
-- Tabela de arenas
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

-- Tabela de controle de módulos por arena
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

-- Tabela de usuários
CREATE TABLE usuarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  auth_id UUID UNIQUE, -- ID do Supabase Auth
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

-- Tabela de professores (extends usuarios)
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

-- Tabela de funcionários (extends usuarios)
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

### **Quadras e Infraestrutura**

```sql
-- Tabela de quadras
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

-- Tabela de bloqueios de quadra
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

-- Tabela de manutenções
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

### **Agendamentos e Check-ins**

```sql
-- Tabela de agendamentos (CRUD Completo)
CREATE TABLE agendamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  
  -- Responsável pelo agendamento
  criado_por_id UUID REFERENCES usuarios(id),
  cliente_principal_id UUID REFERENCES usuarios(id),
  
  -- Data e horário
  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  duracao_minutos INTEGER GENERATED ALWAYS AS (
    EXTRACT(EPOCH FROM (hora_fim - hora_inicio)) / 60
  ) STORED,
  
  -- Tipo e configurações
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
  valor_final DECIMAL(8,2) GENERATED ALWAYS AS (valor_total - COALESCE(desconto_aplicado, 0)) STORED,
  
  -- Status e observações
  status status_agendamento NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  observacoes_internas TEXT,
  
  -- Recorrência
  e_recorrente BOOLEAN DEFAULT false,
  recorrencia_config JSONB DEFAULT '{}',
  agendamento_pai_id UUID REFERENCES agendamentos(id),
  
  -- Check-ins e controle
  permite_checkin BOOLEAN DEFAULT true,
  checkin_aberto_em TIMESTAMPTZ,
  checkin_fechado_em TIMESTAMPTZ,
  checkins JSONB DEFAULT '[]',
  
  -- Comunicação
  notificacoes_enviadas JSONB DEFAULT '[]',
  lembrete_enviado BOOLEAN DEFAULT false,
  
  -- Cancelamento
  data_cancelamento TIMESTAMPTZ,
  motivo_cancelamento TEXT,
  cancelado_por_id UUID REFERENCES usuarios(id),
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  CHECK (hora_fim > hora_inicio),
  CHECK (valor_total >= 0),
  CHECK (max_participantes > 0)
);

-- Tabela de check-ins
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

-- Tabela de lista de espera
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

### **Aulas e Educação**

```sql
-- Tabela de aulas (CRUD Completo)
CREATE TABLE aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE CASCADE,
  professor_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  
  -- Configurações da aula
  nome VARCHAR(150),
  tipo_aula VARCHAR(50) NOT NULL,
  modalidade tipo_esporte NOT NULL,
  nivel_aula nivel_jogo,
  
  -- Alunos
  alunos JSONB DEFAULT '[]',
  max_alunos INTEGER DEFAULT 4,
  min_alunos INTEGER DEFAULT 1,
  
  -- Conteúdo programático
  objetivos TEXT,
  conteudo_programatico TEXT,
  material_necessario JSONB DEFAULT '[]',
  
  -- Valores e duração
  valor_aula DECIMAL(8,2) NOT NULL,
  duracao_minutos INTEGER NOT NULL DEFAULT 60,
  
  -- Check-in e presença
  checkin_habilitado BOOLEAN DEFAULT true,
  checkin_config JSONB DEFAULT '{}',
  presencas JSONB DEFAULT '[]',
  
  -- Avaliação e feedback
  avaliacao_professor JSONB DEFAULT '{}',
  feedback_alunos JSONB DEFAULT '[]',
  notas_professor TEXT,
  
  -- Reposição
  e_reposicao BOOLEAN DEFAULT false,
  aula_original_id UUID REFERENCES aulas(id),
  motivo_reposicao TEXT,
  
  -- Status
  status status_agendamento NOT NULL DEFAULT 'confirmado',
  realizada BOOLEAN DEFAULT false,
  data_realizacao TIMESTAMPTZ,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CHECK (max_alunos >= min_alunos),
  CHECK (valor_aula >= 0)
);

-- Tabela de tipos de aula
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

-- Tabela de pacotes de aulas
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

### **Sistema Financeiro**

```sql
-- Tabela de contratos e mensalidades (CRUD Completo)
CREATE TABLE contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
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
  
  -- Benefícios inclusos
  aulas_incluidas INTEGER DEFAULT 0,
  aulas_utilizadas INTEGER DEFAULT 0,
  horas_quadra_incluidas INTEGER DEFAULT 0,
  horas_quadra_utilizadas INTEGER DEFAULT 0,
  
  -- Políticas
  politica_reposicao JSONB DEFAULT '{}',
  politica_cancelamento JSONB DEFAULT '{}',
  politica_desconto JSONB DEFAULT '{}',
  
  -- Status
  status status_contrato NOT NULL DEFAULT 'ativo',
  motivo_cancelamento TEXT,
  data_cancelamento TIMESTAMPTZ,
  
  -- Observações
  observacoes TEXT,
  clausulas_especiais TEXT,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero_contrato),
  CHECK (data_fim > data_inicio),
  CHECK (valor_mensalidade > 0)
);

-- Tabela de faturas (CRUD Completo)
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
  
  -- Integração Asaas
  asaas_payment_id VARCHAR(100),
  asaas_invoice_url TEXT,
  qr_code_pix TEXT,
  linha_digitavel TEXT,
  
  -- Observações
  observacoes TEXT,
  observacoes_internas TEXT,
  
  -- Histórico de status
  historico_status JSONB DEFAULT '[]',
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero_fatura),
  CHECK (valor_base > 0),
  CHECK (valor_pago >= 0)
);

-- Tabela de movimentações financeiras (CRUD Completo)
CREATE TABLE movimentacoes_financeiras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  
  -- Referências
  fatura_id UUID REFERENCES faturas(id),
  agendamento_id UUID REFERENCES agendamentos(id),
  contrato_id UUID REFERENCES contratos(id),
  usuario_responsavel_id UUID REFERENCES usuarios(id),
  
  -- Dados da movimentação
  tipo tipo_movimentacao NOT NULL,
  categoria categoria_financeira NOT NULL,
  subcategoria VARCHAR(100),
  
  -- Descrição e valores
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
  
  -- Conciliação bancária
  conciliada BOOLEAN DEFAULT false,
  data_conciliacao DATE,
  conta_bancaria VARCHAR(100),
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CHECK (valor != 0)
);
```

### **Torneios e Eventos**

```sql
-- Tabela de torneios (CRUD Completo)
CREATE TABLE torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  criado_por_id UUID REFERENCES usuarios(id),
  
  -- Dados básicos
  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  modalidade tipo_esporte NOT NULL,
  
  -- Datas importantes
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_limite_inscricao TIMESTAMPTZ NOT NULL,
  
  -- Configurações
  max_participantes INTEGER,
  max_duplas INTEGER,
  formato_chaveamento VARCHAR(50) DEFAULT 'eliminacao_simples',
  categoria_nivel nivel_jogo,
  categoria_idade_min INTEGER,
  categoria_idade_max INTEGER,
  categoria_genero genero,
  
  -- Valores
  taxa_inscricao DECIMAL(8,2) NOT NULL DEFAULT 0,
  premiacao_total DECIMAL(8,2) DEFAULT 0,
  distribuicao_premiacao JSONB DEFAULT '{}',
  
  -- Quadras e horários
  quadras_utilizadas JSONB DEFAULT '[]',
  cronograma JSONB DEFAULT '{}',
  
  -- Status
  status status_evento NOT NULL DEFAULT 'planejado',
  
  -- Regulamento
  regulamento TEXT,
  regras_especiais TEXT,
  material_incluido JSONB DEFAULT '[]',
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CHECK (data_fim >= data_inicio),
  CHECK (data_limite_inscricao <= data_inicio),
  CHECK (taxa_inscricao >= 0)
);

-- Tabela de inscrições em torneios (CRUD Completo)
CREATE TABLE inscricoes_torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  
  -- Participantes
  jogador1_id UUID REFERENCES usuarios(id) NOT NULL,
  jogador2_id UUID REFERENCES usuarios(id),
  
  -- Dados da inscrição
  data_inscricao TIMESTAMPTZ DEFAULT NOW(),
  valor_pago DECIMAL(8,2) DEFAULT 0,
  forma_pagamento forma_pagamento,
  
  -- Status
  status status_inscricao NOT NULL DEFAULT 'inscrito',
  posicao_chaveamento INTEGER,
  
  -- Documentação
  documentos_enviados JSONB DEFAULT '[]',
  documentos_aprovados BOOLEAN DEFAULT false,
  
  -- Observações
  observacoes TEXT,
  necessidades_especiais TEXT,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(torneio_id, jogador1_id, jogador2_id)
);

-- Tabela de eventos especiais
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

## SEÇÃO 5: TABELAS DE CONFIGURAÇÃO E GESTÃO

```sql
-- Tabela de configurações da arena
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

-- Tabela de políticas de negócio
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

-- Tabela de histórico de atividades
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

-- Tabela de auditoria
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

---

## SEÇÃO 6: POLÍTICAS RLS (ROW LEVEL SECURITY)

```sql
-- Habilitar RLS em todas as tabelas principais
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE torneios ENABLE ROW LEVEL SECURITY;

-- Política para Super Admin (acesso total)
CREATE POLICY "super_admin_full_access" ON arenas
FOR ALL USING (
  auth.uid() IN (
    SELECT auth_id FROM usuarios 
    WHERE tipo_usuario = 'super_admin'
  )
);

-- Política para isolamento de tenants (usuários só veem dados da própria arena)
CREATE POLICY "tenant_isolation" ON usuarios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para agendamentos (usuários só veem agendamentos da própria arena)
CREATE POLICY "agendamentos_tenant_isolation" ON agendamentos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para quadras (usuários só veem quadras da própria arena)
CREATE POLICY "quadras_tenant_isolation" ON quadras
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para aulas (usuários só veem aulas da própria arena)
CREATE POLICY "aulas_tenant_isolation" ON aulas
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para contratos (usuários só veem contratos da própria arena)
CREATE POLICY "contratos_tenant_isolation" ON contratos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para faturas (usuários só veem faturas da própria arena)
CREATE POLICY "faturas_tenant_isolation" ON faturas
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

-- Política para torneios (usuários só veem torneios da própria arena)
CREATE POLICY "torneios_tenant_isolation" ON torneios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);
```

---

## SEÇÃO 7: TRIGGERS E FUNÇÕES

```sql
-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger em todas as tabelas com updated_at
CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agendamentos_updated_at BEFORE UPDATE ON agendamentos
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Função para auditoria automática
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO auditoria (tabela, operacao, registro_id, dados_novos, usuario_id, arena_id)
    VALUES (TG_TABLE_NAME, 'INSERT', NEW.id, to_jsonb(NEW), 
            (SELECT id FROM usuarios WHERE auth_id = auth.uid()),
            NEW.arena_id);
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO auditoria (tabela, operacao, registro_id, dados_anteriores, dados_novos, usuario_id, arena_id)
    VALUES (TG_TABLE_NAME, 'UPDATE', NEW.id, to_jsonb(OLD), to_jsonb(NEW),
            (SELECT id FROM usuarios WHERE auth_id = auth.uid()),
            NEW.arena_id);
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO auditoria (tabela, operacao, registro_id, dados_anteriores, usuario_id, arena_id)
    VALUES (TG_TABLE_NAME, 'DELETE', OLD.id, to_jsonb(OLD),
            (SELECT id FROM usuarios WHERE auth_id = auth.uid()),
            OLD.arena_id);
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Aplicar triggers de auditoria nas tabelas principais
CREATE TRIGGER audit_usuarios AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_agendamentos AFTER INSERT OR UPDATE OR DELETE ON agendamentos
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_contratos AFTER INSERT OR UPDATE OR DELETE ON contratos
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
```

---

## SEÇÃO 8: ÍNDICES PARA PERFORMANCE

```sql
-- Índices para melhorar performance das consultas mais comuns

-- Índices para tenant isolation
CREATE INDEX idx_usuarios_arena_id ON usuarios(arena_id);
CREATE INDEX idx_usuarios_auth_id ON usuarios(auth_id);
CREATE INDEX idx_agendamentos_arena_id ON agendamentos(arena_id);
CREATE INDEX idx_quadras_arena_id ON quadras(arena_id);

-- Índices para consultas de agendamento
CREATE INDEX idx_agendamentos_data ON agendamentos(data_agendamento);
CREATE INDEX idx_agendamentos_quadra_data ON agendamentos(quadra_id, data_agendamento);
CREATE INDEX idx_agendamentos_cliente ON agendamentos(cliente_principal_id);
CREATE INDEX idx_agendamentos_status ON agendamentos(status);

-- Índices para consultas financeiras
CREATE INDEX idx_faturas_vencimento ON faturas(data_vencimento);
CREATE INDEX idx_faturas_cliente ON faturas(cliente_id);
CREATE INDEX idx_faturas_status ON faturas(status);
CREATE INDEX idx_contratos_cliente ON contratos(cliente_id);
CREATE INDEX idx_movimentacoes_data ON movimentacoes_financeiras(data_movimentacao);

-- Índices para auditoria e logs
CREATE INDEX idx_auditoria_tabela ON auditoria(tabela);
CREATE INDEX idx_auditoria_timestamp ON auditoria(timestamp_operacao);
CREATE INDEX idx_historico_usuario ON historico_atividades(usuario_id);
CREATE INDEX idx_historico_data ON historico_atividades(data_atividade);

-- Índices compostos para consultas complexas
CREATE INDEX idx_agendamentos_arena_data_status ON agendamentos(arena_id, data_agendamento, status);
CREATE INDEX idx_usuarios_arena_tipo ON usuarios(arena_id, tipo_usuario);
CREATE INDEX idx_faturas_arena_status_vencimento ON faturas(arena_id, status, data_vencimento);
```

---

## SEÇÃO 9: DADOS INICIAIS (SEEDS)

```sql
-- Inserir módulos do sistema
INSERT INTO modulos_sistema (nome, codigo, tipo, descricao, ordem) VALUES
('Dashboard', 'dashboard', 'core', 'Painel principal com métricas e visão geral', 1),
('Gestão de Arenas', 'arenas', 'core', 'Configuração e gestão da arena', 2),
('Gestão de Quadras', 'quadras', 'core', 'Cadastro e controle de quadras', 3),
('Gestão de Pessoas', 'pessoas', 'core', 'Cadastro de usuários, professores e alunos', 4),
('Agendamentos', 'agendamentos', 'core', 'Sistema de reservas e agendamentos', 5),
('Gestão de Aulas', 'aulas', 'premium', 'Sistema completo de aulas e matrículas', 6),
('Gestão Financeira', 'financeiro', 'financeiro', 'Controle financeiro e faturamento', 7),
('Torneios e Eventos', 'torneios', 'premium', 'Organização de torneios e eventos', 8),
('Relatórios', 'relatorios', 'relatorios', 'Relatórios e analytics', 9),
('Comunicação', 'comunicacao', 'comunicacao', 'WhatsApp, Email e SMS', 10),
('Integrações', 'integracoes', 'integracao', 'APIs externas e automações', 11);

-- Inserir planos do sistema
INSERT INTO planos_sistema (nome, valor_mensal, max_quadras, max_usuarios, modulos_inclusos) VALUES
('Básico', 89.90, 5, 50, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos"]'),
('Pro', 189.90, 15, 200, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "comunicacao", "relatorios"]'),
('Premium', 389.90, 50, 1000, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "torneios", "comunicacao", "relatorios", "integracoes"]');

-- Inserir relatórios do sistema
INSERT INTO relatorios_sistema (nome, codigo, tipo, nivel_minimo, descricao) VALUES
('Ocupação de Quadras', 'ocupacao_quadras', 'operacional', 'funcionario', 'Relatório de ocupação das quadras por período'),
('Receita Mensal', 'receita_mensal', 'financeiro', 'admin', 'Relatório de receita mensal da arena'),
('Performance de Professores', 'performance_professores', 'performance', 'admin', 'Relatório de performance dos professores'),
('Inadimplência', 'inadimplencia', 'financeiro', 'admin', 'Relatório de clientes inadimplentes'),
('Ranking de Alunos', 'ranking_alunos', 'performance', 'professor', 'Ranking e evolução dos alunos');
```

---

**Status:** ✅ Database schemas completos consolidados  
**Próximo:** Implementação das estruturas no Supabase