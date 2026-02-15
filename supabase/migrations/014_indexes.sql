-- ============================================================================
-- MIGRATION 014: Indexes for Performance
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Base: Legacy v1.0 (comprehensive) + v2.0 additions
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- INDICES: USUARIOS
-- ============================================================
CREATE INDEX idx_usuarios_arena_tipo ON usuarios(arena_id, tipo_usuario);
CREATE INDEX idx_usuarios_arena_email ON usuarios(arena_id, email);
CREATE INDEX idx_usuarios_arena_cpf ON usuarios(arena_id, cpf);
CREATE INDEX idx_usuarios_auth_id ON usuarios(auth_id);
CREATE INDEX idx_usuarios_arena_tipo_status ON usuarios(arena_id, tipo_usuario, status);

-- ============================================================
-- INDICES: QUADRAS
-- ============================================================
CREATE INDEX idx_quadras_arena_status ON quadras(arena_id, status);
CREATE INDEX idx_quadras_arena_tipo ON quadras(arena_id, tipo_esporte);

-- ============================================================
-- INDICES: AGENDAMENTOS
-- ============================================================
CREATE INDEX idx_agendamentos_arena_data ON agendamentos(arena_id, data_agendamento);
CREATE INDEX idx_agendamentos_quadra_data ON agendamentos(quadra_id, data_agendamento);
CREATE INDEX idx_agendamentos_cliente ON agendamentos(cliente_principal_id, data_agendamento);
CREATE INDEX idx_agendamentos_status ON agendamentos(status);
CREATE INDEX idx_agendamentos_arena_data_status ON agendamentos(arena_id, data_agendamento, status);

-- ============================================================
-- INDICES: CHECK-INS
-- ============================================================
CREATE INDEX idx_checkins_agendamento ON checkins(agendamento_id);
CREATE INDEX idx_checkins_usuario_data ON checkins(usuario_id, data_checkin);

-- ============================================================
-- INDICES: AULAS
-- ============================================================
CREATE INDEX idx_aulas_arena_data ON aulas(arena_id, data_aula);
CREATE INDEX idx_aulas_professor_data ON aulas(professor_id, data_aula);
CREATE INDEX idx_matriculas_aula_status ON matriculas_aulas(aula_id, status);

-- ============================================================
-- INDICES: FINANCEIRO
-- ============================================================
CREATE INDEX idx_faturas_arena_vencimento ON faturas(arena_id, data_vencimento);
CREATE INDEX idx_faturas_cliente_status ON faturas(cliente_id, status);
CREATE INDEX idx_faturas_asaas_id ON faturas(asaas_payment_id);
CREATE INDEX idx_faturas_arena_vencimento_status ON faturas(arena_id, data_vencimento, status);
CREATE INDEX idx_contratos_arena_status ON contratos(arena_id, status);
CREATE INDEX idx_contratos_cliente_status ON contratos(cliente_id, status);
CREATE INDEX idx_movimentacoes_arena_data ON movimentacoes(arena_id, data_movimentacao);
CREATE INDEX idx_movimentacoes_data ON movimentacoes(data_movimentacao);

-- ============================================================
-- INDICES: TORNEIOS
-- ============================================================
CREATE INDEX idx_torneios_arena_status ON torneios(arena_id, status);
CREATE INDEX idx_inscricoes_torneio_status ON inscricoes_torneios(torneio_id, status);

-- ============================================================
-- INDICES: NOTIFICACOES
-- ============================================================
CREATE INDEX idx_notificacoes_usuario_status ON notificacoes(usuario_destinatario_id, status);
CREATE INDEX idx_notificacoes_arena_data ON notificacoes(arena_id, created_at);

-- ============================================================
-- INDICES: LOGS E AUDITORIA
-- ============================================================
CREATE INDEX idx_logs_sistema_arena_data ON logs_sistema(arena_id, timestamp);
CREATE INDEX idx_logs_sistema_usuario_data ON logs_sistema(usuario_id, timestamp);
CREATE INDEX idx_auditoria_tabela_data ON auditoria_dados(tabela, timestamp);
CREATE INDEX idx_historico_usuario_data ON historico_atividades(usuario_id, data_atividade);
CREATE INDEX idx_historico_arena_data ON historico_atividades(arena_id, data_atividade);
