# VERANA BEACH TENNIS - SCHEMAS SQL COMPLETOS DO SUPABASE

**Versão: 1.0.0**  
**Data: 27/09/2025**  
**Instruções: Copie e cole cada seção no SQL Editor do Supabase**

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

## SEÇÃO 2: ENUMS E TIPOS PERSONALIZADOS

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
CREATE TYPE status_geral AS ENUM ('ativo', 'inativo', 'suspenso');

-- Tipos de esporte
CREATE TYPE tipo_esporte AS ENUM ('beach_tennis', 'padel', 'tenis');

-- Tipos de piso
CREATE TYPE tipo_piso AS ENUM ('areia', 'saibro', 'sintetico', 'concreto');

-- Status de agendamento
CREATE TYPE status_agendamento AS ENUM ('confirmado', 'pendente', 'cancelado', 'realizado');

-- Status de pagamento
CREATE TYPE status_pagamento AS ENUM ('pendente', 'pago', 'parcial', 'cancelado', 'vencido');

-- Formas de pagamento
CREATE TYPE forma_pagamento AS ENUM ('pix', 'cartao_credito', 'cartao_debito', 'dinheiro', 'boleto', 'credito');

-- Tipos de agendamento
CREATE TYPE tipo_agendamento AS ENUM ('avulso', 'aula', 'torneio', 'evento');

-- Tipos de check-in
CREATE TYPE tipo_checkin AS ENUM ('qrcode', 'geolocalizacao', 'manual', 'biometria');

-- Status de check-in
CREATE TYPE status_checkin AS ENUM ('presente', 'ausente', 'atrasado');

-- Níveis de jogo
CREATE TYPE nivel_jogo AS ENUM ('iniciante', 'intermediario', 'avancado', 'profissional');

-- Gêneros
CREATE TYPE genero AS ENUM ('masculino', 'feminino', 'outro');

-- Dominância
CREATE TYPE dominancia AS ENUM ('destro', 'canhoto', 'ambidestro');

-- Posição preferida
CREATE TYPE posicao_preferida AS ENUM ('rede', 'fundo', 'ambas');

-- Tipos de plano
CREATE TYPE tipo_plano AS ENUM ('mensal', 'trimestral', 'semestral', 'anual');

-- Status de contrato
CREATE TYPE status_contrato AS ENUM ('ativo', 'suspenso', 'cancelado', 'inadimplente');

-- Status de fatura
CREATE TYPE status_fatura AS ENUM ('pendente', 'paga', 'vencida', 'cancelada');

-- Tipos de movimentação financeira
CREATE TYPE tipo_movimentacao AS ENUM ('receita', 'despesa');

-- Categorias financeiras
CREATE TYPE categoria_financeira AS ENUM (
  'mensalidade', 'aula_avulsa', 'torneio', 'manutencao', 
  'comissao', 'material', 'energia', 'outros'
);

-- Status de quadra
CREATE TYPE status_quadra AS ENUM ('ativa', 'manutencao', 'inativa');

-- Tipos de bloqueio
CREATE TYPE tipo_bloqueio AS ENUM ('manutencao', 'evento', 'clima', 'outro');

-- Status de bloqueio
CREATE TYPE status_bloqueio AS ENUM ('ativo', 'cancelado', 'finalizado');

-- Tipos de manutenção
CREATE TYPE tipo_manutencao AS ENUM ('preventiva', 'corretiva', 'emergencial');

-- Status de manutenção
CREATE TYPE status_manutencao AS ENUM ('concluida', 'pendente', 'cancelada');

-- Status de aula
CREATE TYPE status_aula AS ENUM ('agendada', 'realizada', 'cancelada');

-- Status de matrícula
CREATE TYPE status_matricula AS ENUM ('ativa', 'cancelada', 'transferida');

-- Motivos de reposição
CREATE TYPE motivo_reposicao AS ENUM ('falta_aluno', 'falta_professor', 'clima', 'outro');

-- Status de reposição
CREATE TYPE status_reposicao AS ENUM ('pendente', 'agendada', 'utilizada', 'expirada');

-- Status de torneio
CREATE TYPE status_torneio AS ENUM ('inscricoes_abertas', 'em_andamento', 'finalizado', 'cancelado');

-- Categorias de torneio
CREATE TYPE categoria_torneio AS ENUM ('iniciante', 'intermediario', 'avancado', 'mista');

-- Tipos de disputa
CREATE TYPE tipo_disputa AS ENUM ('simples', 'duplas', 'mista');

-- Status de inscrição
CREATE TYPE status_inscricao AS ENUM ('confirmada', 'pendente', 'cancelada');

-- Tipos de chaveamento
CREATE TYPE tipo_chave AS ENUM ('eliminatoria_simples', 'eliminatoria_dupla', 'round_robin');

-- Fases do torneio
CREATE TYPE fase_torneio AS ENUM ('primeira_fase', 'oitavas', 'quartas', 'semi', 'final');

-- Status de partida
CREATE TYPE status_partida AS ENUM ('agendada', 'em_andamento', 'finalizada', 'cancelada');

-- Critérios de sorteio
CREATE TYPE criterio_sorteio AS ENUM ('aleatorio', 'ranking', 'seed');

-- Tipos de evento
CREATE TYPE tipo_evento AS ENUM ('clinica', 'workshop', 'amistoso', 'confraternizacao');

-- Status de evento
CREATE TYPE status_evento AS ENUM ('planejado', 'confirmado', 'realizado', 'cancelado');

-- Tipos de notificação
CREATE TYPE tipo_notificacao AS ENUM ('sistema', 'agendamento', 'pagamento', 'promocao');

-- Canais de envio
CREATE TYPE canal_envio AS ENUM ('app', 'email', 'whatsapp', 'sms');

-- Prioridades
CREATE TYPE prioridade AS ENUM ('baixa', 'media', 'alta', 'urgente');

-- Status de notificação
CREATE TYPE status_notificacao AS ENUM ('pendente', 'enviada', 'lida', 'erro');

-- Tipos de campanha
CREATE TYPE tipo_campanha AS ENUM ('promocional', 'retencao', 'aniversario', 'reativacao');

-- Status de campanha
CREATE TYPE status_campanha AS ENUM ('rascunho', 'agendada', 'enviando', 'concluida');

-- Tipos de comunicação
CREATE TYPE tipo_comunicacao AS ENUM ('whatsapp', 'email', 'sms', 'push', 'ligacao');

-- Status de entrega
CREATE TYPE status_entrega AS ENUM ('enviado', 'entregue', 'lido', 'erro');

-- Tipos de template
CREATE TYPE tipo_template AS ENUM ('confirmacao', 'lembrete', 'cancelamento', 'promocao');

-- Categorias de configuração
CREATE TYPE categoria_config AS ENUM ('agendamento', 'financeiro', 'comunicacao', 'geral', 'seguranca');

-- Tipos de campo
CREATE TYPE tipo_campo AS ENUM ('texto', 'numero', 'boolean', 'lista', 'json');

-- Ambientes
CREATE TYPE ambiente AS ENUM ('sandbox', 'producao');

-- Status de conexão
CREATE TYPE status_conexao AS ENUM ('conectado', 'desconectado', 'erro');

-- Tipos de trigger
CREATE TYPE tipo_trigger AS ENUM ('novo_usuario', 'pagamento_vencido', 'lembrete_aula', 'clima');

-- Níveis de log
CREATE TYPE nivel_log AS ENUM ('info', 'warning', 'error', 'critical');

-- Tipos de operação de auditoria
CREATE TYPE operacao_auditoria AS ENUM ('insert', 'update', 'delete');

-- Origens de operação
CREATE TYPE origem_operacao AS ENUM ('web', 'mobile', 'api', 'sistema');
```

---

## SEÇÃO 3: TABELAS PRINCIPAIS

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

-- Tabela de faturas do sistema (Super Admin)
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
  status status_quadra NOT NULL DEFAULT 'ativa',
  ultima_manutencao DATE,
  proxima_manutencao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de bloqueios de quadra
CREATE TABLE quadras_bloqueios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_bloqueio tipo_bloqueio NOT NULL,
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  responsavel_id UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status status_bloqueio NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de manutenções
CREATE TABLE manutencoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_manutencao tipo_manutencao NOT NULL,
  data_manutencao DATE NOT NULL,
  descricao TEXT NOT NULL,
  fornecedor VARCHAR(100),
  valor_gasto DECIMAL(8,2),
  tempo_parada INTEGER, -- em horas
  responsavel_id UUID REFERENCES usuarios(id),
  proximo_agendamento DATE,
  anexos JSONB DEFAULT '[]',
  status status_manutencao NOT NULL DEFAULT 'concluida',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de equipamentos da quadra
CREATE TABLE equipamentos_quadra (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  nome_equipamento VARCHAR(100) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  marca VARCHAR(50),
  modelo VARCHAR(50),
  data_aquisicao DATE,
  valor_aquisicao DECIMAL(8,2),
  vida_util_estimada INTEGER, -- em meses
  status VARCHAR(20) NOT NULL DEFAULT 'novo',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de agendamentos
CREATE TABLE agendamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id),
  cliente_id UUID REFERENCES usuarios(id),
  tipo_agendamento tipo_agendamento NOT NULL,
  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  valor_total DECIMAL(8,2) NOT NULL,
  valor_pago DECIMAL(8,2) DEFAULT 0,
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,
  observacoes TEXT,
  participantes JSONB DEFAULT '[]',
  equipamentos_solicitados JSONB DEFAULT '[]',
  status_agendamento status_agendamento NOT NULL DEFAULT 'pendente',
  confirmado_em TIMESTAMPTZ,
  cancelado_em TIMESTAMPTZ,
  motivo_cancelamento VARCHAR(200),
  asaas_payment_id VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
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

-- Tabela de agendamentos recorrentes
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

-- Tabela de aulas
CREATE TABLE aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_aula_id UUID REFERENCES tipos_aula(id),
  professor_id UUID REFERENCES professores(id),
  quadra_id UUID REFERENCES quadras(id),
  data_aula DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  max_alunos INTEGER NOT NULL,
  valor_total DECIMAL(8,2) NOT NULL,
  observacoes TEXT,
  material_aula TEXT,
  status status_aula NOT NULL DEFAULT 'agendada',
  avaliacao_professor INTEGER CHECK (avaliacao_professor BETWEEN 1 AND 5),
  feedback_professor TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de matrículas em aulas
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

-- Tabela de reposições
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

-- Tabela de planos de aula
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

-- Tabela de compra de pacotes
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

-- Tabela de planos de pagamento
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

-- Tabela de contratos
CREATE TABLE contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id),
  plano_id UUID REFERENCES planos(id),
  data_inicio DATE NOT NULL,
  data_fim DATE,
  valor_mensal DECIMAL(8,2) NOT NULL,
  dia_vencimento INTEGER NOT NULL CHECK (dia_vencimento BETWEEN 1 AND 31),
  forma_pagamento forma_pagamento NOT NULL,
  dados_pagamento JSONB,
  status status_contrato NOT NULL DEFAULT 'ativo',
  observacoes TEXT,
  asaas_customer_id VARCHAR(50),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de faturas
CREATE TABLE faturas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id),
  contrato_id UUID REFERENCES contratos(id),
  numero_fatura VARCHAR(20) NOT NULL,
  data_vencimento DATE NOT NULL,
  valor_original DECIMAL(8,2) NOT NULL,
  valor_desconto DECIMAL(8,2) DEFAULT 0,
  valor_acrescimo DECIMAL(8,2) DEFAULT 0,
  valor_final DECIMAL(8,2) NOT NULL,
  data_pagamento TIMESTAMPTZ,
  valor_pago DECIMAL(8,2),
  forma_pagamento forma_pagamento,
  asaas_payment_id VARCHAR(50),
  status status_fatura NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero_fatura)
);

-- Tabela de comissões de professores
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

-- Tabela de detalhes das comissões
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

-- Tabela de movimentações financeiras
CREATE TABLE movimentacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_movimentacao tipo_movimentacao NOT NULL,
  categoria categoria_financeira NOT NULL,
  descricao VARCHAR(200) NOT NULL,
  valor DECIMAL(8,2) NOT NULL,
  data_movimentacao DATE NOT NULL,
  forma_pagamento forma_pagamento,
  observacoes TEXT,
  fatura_id UUID REFERENCES faturas(id),
  comissao_id UUID REFERENCES comissoes_professores(id),
  responsavel_id UUID REFERENCES usuarios(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de formas de pagamento
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

-- Tabela de torneios
CREATE TABLE torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(150) NOT NULL,
  modalidade tipo_esporte NOT NULL,
  categoria categoria_torneio NOT NULL,
  tipo_disputa tipo_disputa NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_limite_inscricao DATE NOT NULL,
  max_participantes INTEGER NOT NULL,
  valor_inscricao DECIMAL(8,2) NOT NULL,
  premiacao JSONB,
  regulamento TEXT NOT NULL,
  observacoes TEXT,
  status status_torneio NOT NULL DEFAULT 'inscricoes_abertas',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de inscrições em torneios
CREATE TABLE inscricoes_torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  jogador1_id UUID REFERENCES usuarios(id),
  jogador2_id UUID REFERENCES usuarios(id),
  data_inscricao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  valor_pago DECIMAL(8,2) NOT NULL,
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  status status_inscricao NOT NULL DEFAULT 'pendente',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de chaveamento
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

-- Tabela de partidas do torneio
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

-- Tabela de resultados e rankings
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

-- Tabela de participantes de eventos
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
```

---

## SEÇÃO 4: TABELAS DE GESTÃO E CONFIGURAÇÃO

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
  regras JSONB NOT NULL,
  descricao TEXT NOT NULL,
  ativa BOOLEAN NOT NULL DEFAULT true,
  data_vigencia DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de módulos por arena
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

-- Tabela de permissões
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

-- Tabela de sessões de usuário
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

-- Tabela de histórico de atividades
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

-- Tabela de avaliações de performance
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

-- Tabela de evolução dos alunos
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

-- Tabela de relatórios personalizados
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

-- Tabela de configurações de visibilidade
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
```

---

## SEÇÃO 5: TABELAS DE COMUNICAÇÃO E NOTIFICAÇÕES

```sql
-- Tabela de notificações
CREATE TABLE notificacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  usuario_destinatario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo_notificacao tipo_notificacao NOT NULL,
  titulo VARCHAR(150) NOT NULL,
  mensagem TEXT NOT NULL,
  dados_extras JSONB,
  canal_envio canal_envio NOT NULL,
  prioridade prioridade NOT NULL DEFAULT 'media',
  agendada_para TIMESTAMPTZ,
  enviada_em TIMESTAMPTZ,
  lida_em TIMESTAMPTZ,
  acao_executada BOOLEAN NOT NULL DEFAULT false,
  status status_notificacao NOT NULL DEFAULT 'pendente',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de campanhas de marketing
CREATE TABLE campanhas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_campanha VARCHAR(100) NOT NULL,
  tipo_campanha tipo_campanha NOT NULL,
  publico_alvo JSONB NOT NULL,
  canais_envio JSONB NOT NULL DEFAULT '[]',
  conteudo_mensagem TEXT NOT NULL,
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ,
  total_destinatarios INTEGER NOT NULL DEFAULT 0,
  enviados INTEGER NOT NULL DEFAULT 0,
  abertos INTEGER NOT NULL DEFAULT 0,
  cliques INTEGER NOT NULL DEFAULT 0,
  conversoes INTEGER NOT NULL DEFAULT 0,
  status status_campanha NOT NULL DEFAULT 'rascunho',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de histórico de comunicações
CREATE TABLE historico_comunicacoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  tipo_comunicacao tipo_comunicacao NOT NULL,
  assunto VARCHAR(200) NOT NULL,
  conteudo TEXT NOT NULL,
  remetente VARCHAR(100) NOT NULL,
  data_envio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  data_entrega TIMESTAMPTZ,
  data_leitura TIMESTAMPTZ,
  status_entrega status_entrega NOT NULL DEFAULT 'enviado',
  anexos JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de templates de comunicação
CREATE TABLE templates_comunicacao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_template VARCHAR(100) NOT NULL,
  tipo_template tipo_template NOT NULL,
  canal canal_envio NOT NULL,
  assunto VARCHAR(200),
  conteudo TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de integração WhatsApp
CREATE TABLE integracao_whatsapp (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  api_key VARCHAR(200) NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  numero_whatsapp VARCHAR(15) NOT NULL,
  nome_instancia VARCHAR(50) NOT NULL,
  status_conexao status_conexao NOT NULL DEFAULT 'desconectado',
  ultimo_teste TIMESTAMPTZ,
  templates_configurados JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT false,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de templates WhatsApp
CREATE TABLE templates_whatsapp (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_template VARCHAR(100) NOT NULL,
  tipo_template tipo_template NOT NULL,
  gatilho VARCHAR(50) NOT NULL,
  mensagem TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN NOT NULL DEFAULT true,
  enviados_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de integração Asaas
CREATE TABLE integracao_asaas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  api_key VARCHAR(200) NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  ambiente ambiente NOT NULL DEFAULT 'sandbox',
  status_conexao status_conexao NOT NULL DEFAULT 'desconectado',
  ultimo_teste TIMESTAMPTZ,
  configuracoes_cobranca JSONB NOT NULL DEFAULT '{}',
  taxa_personalizada DECIMAL(5,2),
  ativo BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de automações N8N
CREATE TABLE automacoes_n8n (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome_automacao VARCHAR(100) NOT NULL,
  tipo_trigger tipo_trigger NOT NULL,
  webhook_url VARCHAR(255) NOT NULL,
  workflow_id VARCHAR(50),
  parametros JSONB,
  ultima_execucao TIMESTAMPTZ,
  total_execucoes INTEGER NOT NULL DEFAULT 0,
  ativo BOOLEAN NOT NULL DEFAULT false,
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de logs de execução
CREATE TABLE logs_execucao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  automacao_id UUID REFERENCES automacoes_n8n(id) ON DELETE CASCADE,
  data_execucao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  payload_enviado JSONB,
  resposta_recebida JSONB,
  status VARCHAR(20) NOT NULL,
  tempo_execucao INTEGER, -- em milissegundos
  erro_detalhes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de configurações de backup
CREATE TABLE configuracoes_backup (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  frequencia_backup VARCHAR(20) NOT NULL,
  tipos_dados JSONB NOT NULL DEFAULT '[]',
  local_armazenamento VARCHAR(50) NOT NULL,
  retencao_dias INTEGER NOT NULL DEFAULT 30,
  ultimo_backup TIMESTAMPTZ,
  proximo_backup TIMESTAMPTZ NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de configurações push
CREATE TABLE configuracoes_push (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  tipo_notificacao tipo_notificacao NOT NULL,
  titulo_padrao VARCHAR(100) NOT NULL,
  mensagem_padrao TEXT NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true,
  usuarios_alvo JSONB DEFAULT '[]',
  horario_envio JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## SEÇÃO 6: TABELAS DE AUDITORIA E LOGS

```sql
-- Tabela de logs de sistema
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

-- Tabela de auditoria de dados
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

-- Tabela de configurações gerais
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
```

---

## SEÇÃO 7: ÍNDICES PARA PERFORMANCE

```sql
-- Índices para performance otimizada

-- Índices principais para consultas frequentes
CREATE INDEX idx_usuarios_arena_tipo ON usuarios(arena_id, tipo_usuario);
CREATE INDEX idx_usuarios_arena_email ON usuarios(arena_id, email);
CREATE INDEX idx_usuarios_arena_cpf ON usuarios(arena_id, cpf);
CREATE INDEX idx_usuarios_auth_id ON usuarios(auth_id);

-- Índices para agendamentos
CREATE INDEX idx_agendamentos_arena_data ON agendamentos(arena_id, data_agendamento);
CREATE INDEX idx_agendamentos_quadra_data ON agendamentos(quadra_id, data_agendamento);
CREATE INDEX idx_agendamentos_cliente_data ON agendamentos(cliente_id, data_agendamento);
CREATE INDEX idx_agendamentos_status ON agendamentos(status_agendamento);

-- Índices para check-ins
CREATE INDEX idx_checkins_agendamento ON checkins(agendamento_id);
CREATE INDEX idx_checkins_usuario_data ON checkins(usuario_id, data_checkin);

-- Índices para quadras
CREATE INDEX idx_quadras_arena_status ON quadras(arena_id, status);
CREATE INDEX idx_quadras_arena_tipo ON quadras(arena_id, tipo_esporte);

-- Índices para financeiro
CREATE INDEX idx_faturas_arena_vencimento ON faturas(arena_id, data_vencimento);
CREATE INDEX idx_faturas_cliente_status ON faturas(cliente_id, status);
CREATE INDEX idx_faturas_asaas_id ON faturas(asaas_payment_id);

-- Índices para contratos
CREATE INDEX idx_contratos_arena_status ON contratos(arena_id, status);
CREATE INDEX idx_contratos_cliente_status ON contratos(cliente_id, status);

-- Índices para aulas
CREATE INDEX idx_aulas_arena_data ON aulas(arena_id, data_aula);
CREATE INDEX idx_aulas_professor_data ON aulas(professor_id, data_aula);
CREATE INDEX idx_matriculas_aula_status ON matriculas_aulas(aula_id, status);

-- Índices para torneios
CREATE INDEX idx_torneios_arena_status ON torneios(arena_id, status);
CREATE INDEX idx_inscricoes_torneio_status ON inscricoes_torneios(torneio_id, status);

-- Índices para notificações
CREATE INDEX idx_notificacoes_usuario_status ON notificacoes(usuario_destinatario_id, status);
CREATE INDEX idx_notificacoes_arena_data ON notificacoes(arena_id, created_at);

-- Índices para logs e auditoria
CREATE INDEX idx_logs_sistema_arena_data ON logs_sistema(arena_id, timestamp);
CREATE INDEX idx_logs_sistema_usuario_data ON logs_sistema(usuario_id, timestamp);
CREATE INDEX idx_auditoria_tabela_data ON auditoria_dados(tabela, timestamp);

-- Índices para histórico
CREATE INDEX idx_historico_usuario_data ON historico_atividades(usuario_id, data_atividade);
CREATE INDEX idx_historico_arena_data ON historico_atividades(arena_id, data_atividade);

-- Índices compostos para queries complexas
CREATE INDEX idx_agendamentos_arena_data_status ON agendamentos(arena_id, data_agendamento, status_agendamento);
CREATE INDEX idx_faturas_arena_vencimento_status ON faturas(arena_id, data_vencimento, status);
CREATE INDEX idx_usuarios_arena_tipo_status ON usuarios(arena_id, tipo_usuario, status);
```

---

## SEÇÃO 8: VIEWS PARA RELATÓRIOS

```sql
-- View para estatísticas de ocupação
CREATE VIEW vw_ocupacao_quadras AS
SELECT 
  q.id as quadra_id,
  q.arena_id,
  q.nome as quadra_nome,
  DATE(a.data_agendamento) as data,
  COUNT(a.id) as total_agendamentos,
  SUM(EXTRACT(EPOCH FROM (a.hora_fim - a.hora_inicio))/3600) as horas_ocupadas,
  (SUM(EXTRACT(EPOCH FROM (a.hora_fim - a.hora_inicio))/3600) / 12) * 100 as taxa_ocupacao
FROM quadras q
LEFT JOIN agendamentos a ON q.id = a.quadra_id 
  AND a.status_agendamento = 'realizado'
GROUP BY q.id, q.arena_id, q.nome, DATE(a.data_agendamento);

-- View para estatísticas financeiras
CREATE VIEW vw_receita_mensal AS
SELECT 
  a.arena_id,
  DATE_TRUNC('month', f.data_pagamento) as mes,
  COUNT(f.id) as total_faturas,
  SUM(f.valor_final) as receita_total,
  SUM(CASE WHEN f.status = 'paga' THEN f.valor_final ELSE 0 END) as receita_recebida,
  SUM(CASE WHEN f.status = 'vencida' THEN f.valor_final ELSE 0 END) as receita_vencida
FROM arenas a
LEFT JOIN faturas f ON a.id = f.arena_id
WHERE f.data_pagamento IS NOT NULL
GROUP BY a.arena_id, DATE_TRUNC('month', f.data_pagamento);

-- View para performance de professores
CREATE VIEW vw_performance_professores AS
SELECT 
  p.id as professor_id,
  u.nome_completo as professor_nome,
  u.arena_id,
  COUNT(a.id) as total_aulas,
  COUNT(CASE WHEN a.status = 'realizada' THEN 1 END) as aulas_realizadas,
  COUNT(CASE WHEN a.status = 'cancelada' THEN 1 END) as aulas_canceladas,
  AVG(CASE WHEN a.avaliacao_professor IS NOT NULL THEN a.avaliacao_professor END) as avaliacao_media,
  SUM(CASE WHEN a.status = 'realizada' THEN a.valor_total ELSE 0 END) as receita_gerada
FROM professores p
JOIN usuarios u ON p.usuario_id = u.id
LEFT JOIN aulas a ON p.id = a.professor_id
GROUP BY p.id, u.nome_completo, u.arena_id;

-- View para estatísticas de alunos
CREATE VIEW vw_estatisticas_alunos AS
SELECT 
  u.id as aluno_id,
  u.nome_completo as aluno_nome,
  u.arena_id,
  COUNT(ma.id) as total_matriculas,
  COUNT(CASE WHEN ma.presente = true THEN 1 END) as aulas_presentes,
  COUNT(CASE WHEN ma.presente = false THEN 1 END) as aulas_ausentes,
  (COUNT(CASE WHEN ma.presente = true THEN 1 END) * 100.0 / NULLIF(COUNT(ma.id), 0)) as percentual_presenca,
  SUM(ma.valor_pago) as total_gasto
FROM usuarios u
LEFT JOIN matriculas_aulas ma ON u.id = ma.aluno_id
WHERE u.tipo_usuario = 'aluno'
GROUP BY u.id, u.nome_completo, u.arena_id;

-- View para dashboard resumo
CREATE VIEW vw_dashboard_resumo AS
SELECT 
  a.id as arena_id,
  a.nome as arena_nome,
  COUNT(DISTINCT u.id) FILTER (WHERE u.tipo_usuario = 'aluno') as total_alunos,
  COUNT(DISTINCT u.id) FILTER (WHERE u.tipo_usuario = 'professor') as total_professores,
  COUNT(DISTINCT q.id) as total_quadras,
  COUNT(DISTINCT ag.id) FILTER (WHERE ag.data_agendamento = CURRENT_DATE) as agendamentos_hoje,
  SUM(f.valor_final) FILTER (WHERE f.status = 'paga' AND DATE_TRUNC('month', f.data_pagamento) = DATE_TRUNC('month', CURRENT_DATE)) as receita_mes_atual
FROM arenas a
LEFT JOIN usuarios u ON a.id = u.arena_id
LEFT JOIN quadras q ON a.id = q.arena_id
LEFT JOIN agendamentos ag ON a.id = ag.arena_id
LEFT JOIN faturas f ON a.id = f.arena_id
GROUP BY a.id, a.nome;
```

---

## SEÇÃO 9: TRIGGERS PARA AUDITORIA

```sql
-- Função para auditoria automática
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO auditoria_dados (
      arena_id, tabela, operacao, registro_id, 
      usuario_responsavel, dados_novos, origem
    ) VALUES (
      COALESCE(NEW.arena_id, (SELECT arena_id FROM usuarios WHERE id = NEW.usuario_id LIMIT 1)),
      TG_TABLE_NAME::varchar, 'insert', NEW.id,
      current_setting('app.current_user_id', true)::uuid,
      to_jsonb(NEW), 'web'
    );
    RETURN NEW;
  END IF;
  
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO auditoria_dados (
      arena_id, tabela, operacao, registro_id,
      usuario_responsavel, dados_anteriores, dados_novos, origem
    ) VALUES (
      COALESCE(NEW.arena_id, OLD.arena_id, (SELECT arena_id FROM usuarios WHERE id = NEW.usuario_id LIMIT 1)),
      TG_TABLE_NAME::varchar, 'update', NEW.id,
      current_setting('app.current_user_id', true)::uuid,
      to_jsonb(OLD), to_jsonb(NEW), 'web'
    );
    RETURN NEW;
  END IF;
  
  IF TG_OP = 'DELETE' THEN
    INSERT INTO auditoria_dados (
      arena_id, tabela, operacao, registro_id,
      usuario_responsavel, dados_anteriores, origem
    ) VALUES (
      COALESCE(OLD.arena_id, (SELECT arena_id FROM usuarios WHERE id = OLD.usuario_id LIMIT 1)),
      TG_TABLE_NAME::varchar, 'delete', OLD.id,
      current_setting('app.current_user_id', true)::uuid,
      to_jsonb(OLD), 'web'
    );
    RETURN OLD;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Aplicar triggers de auditoria nas tabelas críticas
CREATE TRIGGER audit_usuarios AFTER INSERT OR UPDATE OR DELETE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_agendamentos AFTER INSERT OR UPDATE OR DELETE ON agendamentos
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_faturas AFTER INSERT OR UPDATE OR DELETE ON faturas
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_quadras AFTER INSERT OR UPDATE OR DELETE ON quadras
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_aulas AFTER INSERT OR UPDATE OR DELETE ON aulas
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de updated_at em todas as tabelas relevantes
CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agendamentos_updated_at BEFORE UPDATE ON agendamentos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger para gerar número de fatura automaticamente
CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TRIGGER AS $$
DECLARE
  next_number INTEGER;
BEGIN
  SELECT COALESCE(MAX(CAST(SUBSTRING(numero_fatura FROM '[0-9]+') AS INTEGER)), 0) + 1
  INTO next_number
  FROM faturas 
  WHERE arena_id = NEW.arena_id;
  
  NEW.numero_fatura = LPAD(next_number::text, 6, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_faturas_number BEFORE INSERT ON faturas
  FOR EACH ROW EXECUTE FUNCTION generate_invoice_number();
```

---

## SEÇÃO 10: ROW LEVEL SECURITY (RLS)

```sql
-- Habilitar RLS em todas as tabelas
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE torneios ENABLE ROW LEVEL SECURITY;
ALTER TABLE notificacoes ENABLE ROW LEVEL SECURITY;

-- Políticas para arenas
CREATE POLICY "Super admins can view all arenas" ON arenas
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario = 'super_admin'
    )
  );

CREATE POLICY "Arena admins can view own arena" ON arenas
  FOR SELECT USING (
    id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('arena_admin', 'funcionario', 'professor', 'aluno')
    )
  );

-- Políticas para usuários
CREATE POLICY "Users can view users from same arena" ON usuarios
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena admins can manage users" ON usuarios
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin')
    )
  );

CREATE POLICY "Users can update own profile" ON usuarios
  FOR UPDATE USING (auth_id = auth.uid());

-- Políticas para quadras
CREATE POLICY "Users can view quadras from same arena" ON quadras
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena admins can manage quadras" ON quadras
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin', 'funcionario')
    )
  );

-- Políticas para agendamentos
CREATE POLICY "Users can view agendamentos from same arena" ON agendamentos
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Users can view own agendamentos" ON agendamentos
  FOR SELECT USING (
    cliente_id IN (
      SELECT id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Users can create own agendamentos" ON agendamentos
  FOR INSERT WITH CHECK (
    cliente_id IN (
      SELECT id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena staff can manage all agendamentos" ON agendamentos
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin', 'funcionario')
    )
  );

-- Políticas para faturas
CREATE POLICY "Users can view faturas from same arena" ON faturas
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Users can view own faturas" ON faturas
  FOR SELECT USING (
    cliente_id IN (
      SELECT id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena admins can manage faturas" ON faturas
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin', 'funcionario')
    )
  );

-- Políticas para aulas
CREATE POLICY "Users can view aulas from same arena" ON aulas
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Professors can manage own aulas" ON aulas
  FOR ALL USING (
    professor_id IN (
      SELECT p.id FROM professores p
      JOIN usuarios u ON p.usuario_id = u.id
      WHERE u.auth_id = auth.uid()
    )
  );

-- Políticas para torneios
CREATE POLICY "Users can view torneios from same arena" ON torneios
  FOR SELECT USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena admins can manage torneios" ON torneios
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin', 'funcionario')
    )
  );

-- Políticas para notificações
CREATE POLICY "Users can view own notifications" ON notificacoes
  FOR SELECT USING (
    usuario_destinatario_id IN (
      SELECT id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  );

CREATE POLICY "Arena admins can manage notifications" ON notificacoes
  FOR ALL USING (
    arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid() 
      AND tipo_usuario IN ('super_admin', 'arena_admin')
    )
  );
```

---

## SEÇÃO 11: DADOS INICIAIS (SEEDS)

```sql
-- Inserir planos do sistema
INSERT INTO planos_sistema (nome, valor_mensal, max_quadras, max_usuarios, modulos_inclusos, descricao) VALUES
('Básico', 39.90, 3, 50, '["agendamentos", "usuarios", "quadras"]', 'Plano básico para arenas pequenas'),
('Pro', 89.90, 10, 200, '["agendamentos", "usuarios", "quadras", "aulas", "financeiro", "whatsapp"]', 'Plano completo para arenas médias'),
('Premium', 159.90, 999, 999, '["agendamentos", "usuarios", "quadras", "aulas", "financeiro", "whatsapp", "torneios", "relatorios", "automacoes"]', 'Plano premium com todas as funcionalidades');

-- Inserir configurações padrão (serão aplicadas automaticamente nas novas arenas)
INSERT INTO configuracoes_arena (arena_id, categoria, chave, valor, descricao) 
SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid, -- Placeholder para template
  'agendamento',
  'antecedencia_maxima_dias',
  '30'::jsonb,
  'Quantos dias de antecedência máxima para agendamentos'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'agendamento',
  'antecedencia_minima_horas',
  '2'::jsonb,
  'Quantas horas de antecedência mínima para agendamentos'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'agendamento',
  'tempo_tolerancia_checkin_minutos',
  '15'::jsonb,
  'Tempo de tolerância para check-in após horário marcado'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'financeiro',
  'dias_vencimento_padrao',
  '7'::jsonb,
  'Dias padrão para vencimento de faturas'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'financeiro',
  'juros_mensal_atraso',
  '2.0'::jsonb,
  'Juros mensal para pagamentos em atraso (%)'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'comunicacao',
  'enviar_lembrete_24h',
  'true'::jsonb,
  'Enviar lembrete automático 24h antes'
UNION ALL SELECT 
  '00000000-0000-0000-0000-000000000000'::uuid,
  'comunicacao',
  'enviar_lembrete_2h',
  'true'::jsonb,
  'Enviar lembrete automático 2h antes';

-- Função para aplicar configurações padrão em novas arenas
CREATE OR REPLACE FUNCTION apply_default_configurations()
RETURNS TRIGGER AS $$
BEGIN
  -- Copiar configurações padrão para a nova arena
  INSERT INTO configuracoes_arena (arena_id, categoria, chave, valor, descricao)
  SELECT 
    NEW.id,
    categoria,
    chave,
    valor,
    descricao
  FROM configuracoes_arena 
  WHERE arena_id = '00000000-0000-0000-0000-000000000000'::uuid;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para aplicar configurações padrão
CREATE TRIGGER apply_default_config_trigger
  AFTER INSERT ON arenas
  FOR EACH ROW
  EXECUTE FUNCTION apply_default_configurations();
```

---

## INSTRUÇÕES DE EXECUÇÃO

### **1. ORDEM DE EXECUÇÃO:**
Execute as seções na ordem apresentada (1 → 11), uma por vez no SQL Editor do Supabase.

### **2. VERIFICAÇÃO:**
Após cada seção, verifique se não há erros antes de continuar.

### **3. VALIDAÇÃO FINAL:**
```sql
-- Verificar se todas as tabelas foram criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Verificar RLS habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Verificar triggers criados
SELECT trigger_name, event_object_table 
FROM information_schema.triggers 
WHERE trigger_schema = 'public';
```

### **4. CONFIGURAÇÃO AUTH:**
Após executar todos os schemas, configure a autenticação no Supabase Dashboard:
- Authentication → Settings → Confirme que RLS está habilitado
- Authentication → Policies → Verifique se as políticas foram criadas

**Status:** ✅ Schemas SQL completos prontos para execução