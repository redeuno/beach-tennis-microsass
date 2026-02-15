-- ============================================================================
-- MIGRATION 002: ENUMs e Tipos Personalizados
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Base: Legacy v1.0 (~45 ENUMs) + v2.0 expanded values
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- ENUMS DE USUARIO E ACESSO
-- ============================================================

-- Tipos de usuario (hierarquia: super_admin > arena_admin > funcionario/professor > aluno)
CREATE TYPE user_role AS ENUM (
  'super_admin',
  'arena_admin',
  'funcionario',
  'professor',
  'aluno'
);

-- Generos
CREATE TYPE genero AS ENUM ('masculino', 'feminino', 'outro', 'nao_informado');

-- Dominancia de mao
CREATE TYPE dominancia AS ENUM ('destro', 'canhoto', 'ambidestro');

-- Posicao preferida na quadra
CREATE TYPE posicao_preferida AS ENUM ('rede', 'fundo', 'ambas', 'especialista_rede', 'especialista_fundo');

-- Niveis de jogo
CREATE TYPE nivel_jogo AS ENUM ('iniciante', 'intermediario', 'intermediario_avancado', 'avancado', 'profissional');

-- ============================================================
-- ENUMS DE STATUS GERAL
-- ============================================================

-- Status gerais reutilizavel
CREATE TYPE status_geral AS ENUM ('ativo', 'inativo', 'suspenso', 'bloqueado');

-- ============================================================
-- ENUMS DE QUADRAS E INFRAESTRUTURA
-- ============================================================

-- Tipos de esporte suportados
CREATE TYPE tipo_esporte AS ENUM ('beach_tennis', 'padel', 'tenis', 'futevolei');

-- Tipos de piso
CREATE TYPE tipo_piso AS ENUM ('areia', 'saibro', 'sintetico', 'concreto', 'grama');

-- Status de quadra
CREATE TYPE status_quadra AS ENUM ('ativa', 'manutencao', 'inativa');

-- Tipos de bloqueio de quadra
CREATE TYPE tipo_bloqueio AS ENUM ('manutencao', 'evento', 'clima', 'outro');

-- Status de bloqueio
CREATE TYPE status_bloqueio AS ENUM ('ativo', 'cancelado', 'finalizado');

-- Tipos de manutencao
CREATE TYPE tipo_manutencao AS ENUM ('preventiva', 'corretiva', 'emergencial');

-- Status de manutencao
CREATE TYPE status_manutencao AS ENUM ('concluida', 'pendente', 'cancelada');

-- ============================================================
-- ENUMS DE AGENDAMENTO
-- ============================================================

-- Status de agendamento
CREATE TYPE status_agendamento AS ENUM ('confirmado', 'pendente', 'cancelado', 'realizado', 'no_show');

-- Tipos de agendamento
CREATE TYPE tipo_agendamento AS ENUM ('avulso', 'aula', 'torneio', 'evento', 'manutencao', 'bloqueio');

-- Tipos de check-in
CREATE TYPE tipo_checkin AS ENUM ('qrcode', 'geolocalizacao', 'manual', 'biometria', 'facial');

-- Status de check-in
CREATE TYPE status_checkin AS ENUM ('presente', 'ausente', 'atrasado', 'cancelado');

-- ============================================================
-- ENUMS DE AULAS
-- ============================================================

-- Status de aula
CREATE TYPE status_aula AS ENUM ('agendada', 'realizada', 'cancelada');

-- Status de matricula
CREATE TYPE status_matricula AS ENUM ('ativa', 'cancelada', 'transferida');

-- Motivos de reposicao
CREATE TYPE motivo_reposicao AS ENUM ('falta_aluno', 'falta_professor', 'clima', 'outro');

-- Status de reposicao
CREATE TYPE status_reposicao AS ENUM ('pendente', 'agendada', 'utilizada', 'expirada');

-- ============================================================
-- ENUMS FINANCEIROS
-- ============================================================

-- Status de pagamento
CREATE TYPE status_pagamento AS ENUM ('pendente', 'pago', 'parcial', 'cancelado', 'vencido', 'estornado');

-- Formas de pagamento
CREATE TYPE forma_pagamento AS ENUM ('pix', 'cartao_credito', 'cartao_debito', 'dinheiro', 'boleto', 'credito', 'transferencia');

-- Tipos de plano (mensalidade de aluno na arena)
CREATE TYPE tipo_plano AS ENUM ('mensal', 'trimestral', 'semestral', 'anual', 'avulso');

-- Status de contrato
CREATE TYPE status_contrato AS ENUM ('ativo', 'suspenso', 'cancelado', 'inadimplente', 'pausado');

-- Status de fatura
CREATE TYPE status_fatura AS ENUM ('pendente', 'paga', 'vencida', 'cancelada', 'parcial');

-- Tipos de movimentacao financeira
CREATE TYPE tipo_movimentacao AS ENUM ('receita', 'despesa', 'transferencia', 'estorno');

-- Categorias financeiras
CREATE TYPE categoria_financeira AS ENUM (
  'mensalidade', 'aula_avulsa', 'aluguel_quadra', 'torneio', 'evento',
  'produto', 'multa', 'taxa', 'desconto', 'promocao',
  'manutencao', 'equipamento', 'funcionario', 'marketing', 'outros'
);

-- ============================================================
-- ENUMS DE TORNEIOS E EVENTOS
-- ============================================================

-- Status de torneio
CREATE TYPE status_torneio AS ENUM ('inscricoes_abertas', 'em_andamento', 'finalizado', 'cancelado');

-- Categorias de torneio
CREATE TYPE categoria_torneio AS ENUM ('iniciante', 'intermediario', 'avancado', 'mista');

-- Tipos de disputa
CREATE TYPE tipo_disputa AS ENUM ('simples', 'duplas', 'mista');

-- Status de inscricao (torneios + eventos)
CREATE TYPE status_inscricao AS ENUM ('inscrito', 'confirmada', 'pendente', 'cancelada', 'lista_espera', 'presente', 'ausente');

-- Tipos de chaveamento
CREATE TYPE tipo_chave AS ENUM ('eliminatoria_simples', 'eliminatoria_dupla', 'round_robin');

-- Fases do torneio
CREATE TYPE fase_torneio AS ENUM ('primeira_fase', 'oitavas', 'quartas', 'semi', 'final');

-- Status de partida
CREATE TYPE status_partida AS ENUM ('agendada', 'em_andamento', 'finalizada', 'cancelada');

-- Criterios de sorteio
CREATE TYPE criterio_sorteio AS ENUM ('aleatorio', 'ranking', 'seed');

-- Tipos de evento
CREATE TYPE tipo_evento AS ENUM ('clinica', 'workshop', 'amistoso', 'confraternizacao', 'festa', 'campeonato', 'promocional', 'corporativo');

-- Status de evento
CREATE TYPE status_evento AS ENUM ('planejado', 'divulgado', 'aberto', 'confirmado', 'realizado', 'cancelado');

-- ============================================================
-- ENUMS DE COMUNICACAO E NOTIFICACOES
-- ============================================================

-- Tipos de notificacao
CREATE TYPE tipo_notificacao AS ENUM ('sistema', 'agendamento', 'pagamento', 'promocao');

-- Canais de envio
CREATE TYPE canal_envio AS ENUM ('app', 'email', 'whatsapp', 'sms');

-- Prioridades
CREATE TYPE prioridade AS ENUM ('baixa', 'media', 'alta', 'urgente');

-- Status de notificacao
CREATE TYPE status_notificacao AS ENUM ('pendente', 'enviada', 'lida', 'erro');

-- Tipos de campanha
CREATE TYPE tipo_campanha AS ENUM ('promocional', 'retencao', 'aniversario', 'reativacao');

-- Status de campanha
CREATE TYPE status_campanha AS ENUM ('rascunho', 'agendada', 'enviando', 'concluida');

-- Tipos de comunicacao
CREATE TYPE tipo_comunicacao AS ENUM ('whatsapp', 'email', 'sms', 'push', 'ligacao');

-- Status de entrega
CREATE TYPE status_entrega AS ENUM ('enviado', 'entregue', 'lido', 'erro');

-- Tipos de template
CREATE TYPE tipo_template AS ENUM ('confirmacao', 'lembrete', 'cancelamento', 'promocao');

-- ============================================================
-- ENUMS DE CONFIGURACAO E SISTEMA
-- ============================================================

-- Categorias de configuracao
CREATE TYPE categoria_config AS ENUM (
  'geral', 'financeiro', 'agendamento', 'comunicacao', 'integracao',
  'relatorio', 'seguranca', 'personalizacao', 'automacao'
);

-- Tipos de campo de configuracao
CREATE TYPE tipo_campo AS ENUM ('texto', 'numero', 'boolean', 'lista', 'json');

-- Ambientes de integracao
CREATE TYPE ambiente AS ENUM ('sandbox', 'producao');

-- Status de conexao (integracoes)
CREATE TYPE status_conexao AS ENUM ('conectado', 'desconectado', 'erro');

-- Tipos de trigger (automacoes n8n)
CREATE TYPE tipo_trigger AS ENUM ('novo_usuario', 'pagamento_vencido', 'lembrete_aula', 'clima');

-- Niveis de log
CREATE TYPE nivel_log AS ENUM ('info', 'warning', 'error', 'critical');

-- Tipos de operacao de auditoria
CREATE TYPE operacao_auditoria AS ENUM ('insert', 'update', 'delete');

-- Origens de operacao
CREATE TYPE origem_operacao AS ENUM ('web', 'mobile', 'api', 'sistema');

-- ============================================================
-- ENUMS ADICIONAIS (v2.0)
-- ============================================================

-- Tipos de relatorio
CREATE TYPE tipo_relatorio AS ENUM (
  'operacional', 'financeiro', 'marketing', 'performance', 'administrativo'
);

-- Niveis de acesso a relatorios
CREATE TYPE nivel_acesso_relatorio AS ENUM (
  'publico', 'professor', 'funcionario', 'admin', 'super_admin'
);

-- Status de modulo
CREATE TYPE status_modulo AS ENUM ('ativo', 'inativo', 'beta', 'deprecated');

-- Tipos de modulo
CREATE TYPE tipo_modulo AS ENUM (
  'core', 'financeiro', 'comunicacao', 'relatorios', 'integracao', 'premium'
);
