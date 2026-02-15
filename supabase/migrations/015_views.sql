-- ============================================================================
-- MIGRATION 015: Views for Reports and Dashboard
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Views: vw_ocupacao_quadras, vw_receita_mensal, vw_performance_professores,
--        vw_estatisticas_alunos, vw_dashboard_resumo
-- Base: Legacy v1.0 (5 views completas)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- VIEW: Ocupacao de Quadras
-- Mostra taxa de ocupacao por quadra e dia
-- ============================================================
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
  AND a.status = 'realizado'
GROUP BY q.id, q.arena_id, q.nome, DATE(a.data_agendamento);

-- ============================================================
-- VIEW: Receita Mensal
-- Mostra receita total, recebida e vencida por mes
-- ============================================================
CREATE VIEW vw_receita_mensal AS
SELECT
  ar.arena_id,
  DATE_TRUNC('month', f.data_pagamento) as mes,
  COUNT(f.id) as total_faturas,
  SUM(f.valor_base) as receita_total,
  SUM(CASE WHEN f.status = 'paga' THEN f.valor_base ELSE 0 END) as receita_recebida,
  SUM(CASE WHEN f.status = 'vencida' THEN f.valor_base ELSE 0 END) as receita_vencida
FROM arenas ar
LEFT JOIN faturas f ON ar.id = f.arena_id
WHERE f.data_pagamento IS NOT NULL
GROUP BY ar.arena_id, DATE_TRUNC('month', f.data_pagamento);

-- ============================================================
-- VIEW: Performance de Professores
-- Mostra metricas de cada professor
-- ============================================================
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

-- ============================================================
-- VIEW: Estatisticas de Alunos
-- Mostra presenca e gastos de cada aluno
-- ============================================================
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

-- ============================================================
-- VIEW: Dashboard Resumo
-- Visao geral da arena para o dashboard principal
-- ============================================================
CREATE VIEW vw_dashboard_resumo AS
SELECT
  a.id as arena_id,
  a.nome as arena_nome,
  COUNT(DISTINCT u.id) FILTER (WHERE u.tipo_usuario = 'aluno') as total_alunos,
  COUNT(DISTINCT u.id) FILTER (WHERE u.tipo_usuario = 'professor') as total_professores,
  COUNT(DISTINCT q.id) as total_quadras,
  COUNT(DISTINCT ag.id) FILTER (WHERE ag.data_agendamento = CURRENT_DATE) as agendamentos_hoje,
  SUM(f.valor_base) FILTER (WHERE f.status = 'paga' AND DATE_TRUNC('month', f.data_pagamento) = DATE_TRUNC('month', CURRENT_DATE)) as receita_mes_atual
FROM arenas a
LEFT JOIN usuarios u ON a.id = u.arena_id
LEFT JOIN quadras q ON a.id = q.arena_id
LEFT JOIN agendamentos ag ON a.id = ag.arena_id
LEFT JOIN faturas f ON a.id = f.arena_id
GROUP BY a.id, a.nome;
