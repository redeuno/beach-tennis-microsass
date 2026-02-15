-- ============================================================================
-- MIGRATION 016: Seed Data (Initial Data)
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Seeds: modulos_sistema, planos_sistema, relatorios_sistema,
--         configuracoes_arena (template padrao)
-- Base: v1.0 prices (R$39.90/89.90/159.90) + v2.0 modulos catalog
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- MODULOS DO SISTEMA (catalogo completo)
-- ============================================================
INSERT INTO modulos_sistema (nome, codigo, tipo, descricao, ordem) VALUES
('Dashboard', 'dashboard', 'core', 'Painel principal com metricas e visao geral', 1),
('Gestao de Arenas', 'arenas', 'core', 'Configuracao e gestao da arena', 2),
('Gestao de Quadras', 'quadras', 'core', 'Cadastro e controle de quadras', 3),
('Gestao de Pessoas', 'pessoas', 'core', 'Cadastro de usuarios, professores e alunos', 4),
('Agendamentos', 'agendamentos', 'core', 'Sistema de reservas e agendamentos', 5),
('Gestao de Aulas', 'aulas', 'premium', 'Sistema completo de aulas e matriculas', 6),
('Gestao Financeira', 'financeiro', 'financeiro', 'Controle financeiro e faturamento', 7),
('Torneios e Eventos', 'torneios', 'premium', 'Organizacao de torneios e eventos', 8),
('Relatorios', 'relatorios', 'relatorios', 'Relatorios e analytics', 9),
('Comunicacao', 'comunicacao', 'comunicacao', 'WhatsApp, Email e SMS', 10),
('Integracoes', 'integracoes', 'integracao', 'APIs externas e automacoes', 11);

-- ============================================================
-- PLANOS DO SISTEMA
-- Precos v1.0: Basico R$39.90 | Pro R$89.90 | Premium R$159.90
-- ============================================================
INSERT INTO planos_sistema (nome, valor_mensal, max_quadras, max_usuarios, modulos_inclusos, descricao) VALUES
(
  'Basico',
  39.90,
  3,
  50,
  '["dashboard", "arenas", "quadras", "pessoas", "agendamentos"]',
  'Plano basico para arenas pequenas - ate 3 quadras e 50 usuarios'
),
(
  'Pro',
  89.90,
  10,
  200,
  '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "comunicacao", "relatorios"]',
  'Plano completo para arenas medias - ate 10 quadras e 200 usuarios'
),
(
  'Premium',
  159.90,
  999,
  999,
  '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "torneios", "comunicacao", "relatorios", "integracoes"]',
  'Plano premium com todas as funcionalidades - quadras e usuarios ilimitados'
);

-- ============================================================
-- RELATORIOS DO SISTEMA (catalogo)
-- ============================================================
INSERT INTO relatorios_sistema (nome, codigo, tipo, nivel_minimo, descricao) VALUES
('Ocupacao de Quadras', 'ocupacao_quadras', 'operacional', 'funcionario', 'Relatorio de ocupacao das quadras por periodo'),
('Receita Mensal', 'receita_mensal', 'financeiro', 'admin', 'Relatorio de receita mensal da arena'),
('Performance de Professores', 'performance_professores', 'performance', 'admin', 'Relatorio de performance dos professores'),
('Inadimplencia', 'inadimplencia', 'financeiro', 'admin', 'Relatorio de clientes inadimplentes'),
('Ranking de Alunos', 'ranking_alunos', 'performance', 'professor', 'Ranking e evolucao dos alunos');

-- ============================================================
-- CONFIGURACOES PADRAO (template para novas arenas)
-- Usa UUID zero como template - sera copiado automaticamente
-- para cada nova arena via trigger apply_default_configurations()
-- ============================================================
INSERT INTO configuracoes_arena (arena_id, categoria, chave, valor, descricao)
VALUES
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'agendamento',
  'antecedencia_maxima_dias',
  '30'::jsonb,
  'Quantos dias de antecedencia maxima para agendamentos'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'agendamento',
  'antecedencia_minima_horas',
  '2'::jsonb,
  'Quantas horas de antecedencia minima para agendamentos'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'agendamento',
  'tempo_tolerancia_checkin_minutos',
  '15'::jsonb,
  'Tempo de tolerancia para check-in apos horario marcado'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'financeiro',
  'dias_vencimento_padrao',
  '7'::jsonb,
  'Dias padrao para vencimento de faturas'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'financeiro',
  'juros_mensal_atraso',
  '2.0'::jsonb,
  'Juros mensal para pagamentos em atraso (%)'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'comunicacao',
  'enviar_lembrete_24h',
  'true'::jsonb,
  'Enviar lembrete automatico 24h antes'
),
(
  '00000000-0000-0000-0000-000000000000'::uuid,
  'comunicacao',
  'enviar_lembrete_2h',
  'true'::jsonb,
  'Enviar lembrete automatico 2h antes'
);
