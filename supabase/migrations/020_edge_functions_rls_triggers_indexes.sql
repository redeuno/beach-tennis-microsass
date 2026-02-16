-- ============================================================================
-- MIGRATION 020: RLS, Triggers e Indexes para tabelas da Migration 019
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- HABILITAR RLS NAS NOVAS TABELAS
-- ============================================================
ALTER TABLE fila_mensagens ENABLE ROW LEVEL SECURITY;
ALTER TABLE chatbot_conversas ENABLE ROW LEVEL SECURITY;
ALTER TABLE chatbot_mensagens ENABLE ROW LEVEL SECURITY;
ALTER TABLE insights_arena ENABLE ROW LEVEL SECURITY;
ALTER TABLE cron_jobs_config ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- POLITICAS: FILA DE MENSAGENS
-- ============================================================
CREATE POLICY "fila_mensagens_super_admin" ON fila_mensagens
  FOR ALL USING (is_super_admin());

CREATE POLICY "fila_mensagens_arena_admin" ON fila_mensagens
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );

CREATE POLICY "fila_mensagens_arena_view" ON fila_mensagens
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
  );

-- ============================================================
-- POLITICAS: CHATBOT CONVERSAS
-- ============================================================
CREATE POLICY "chatbot_conversas_super_admin" ON chatbot_conversas
  FOR ALL USING (is_super_admin());

CREATE POLICY "chatbot_conversas_arena_admin" ON chatbot_conversas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
  );

CREATE POLICY "chatbot_conversas_self_view" ON chatbot_conversas
  FOR SELECT USING (
    usuario_id = auth_user_id()
  );

-- ============================================================
-- POLITICAS: CHATBOT MENSAGENS
-- ============================================================
CREATE POLICY "chatbot_mensagens_super_admin" ON chatbot_mensagens
  FOR ALL USING (is_super_admin());

CREATE POLICY "chatbot_mensagens_arena_view" ON chatbot_mensagens
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM chatbot_conversas c
      WHERE c.id = chatbot_mensagens.conversa_id
      AND c.arena_id = auth_user_arena_id()
    )
  );

CREATE POLICY "chatbot_mensagens_arena_manage" ON chatbot_mensagens
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM chatbot_conversas c
      WHERE c.id = chatbot_mensagens.conversa_id
      AND c.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario')
  );

-- ============================================================
-- POLITICAS: INSIGHTS ARENA
-- ============================================================
CREATE POLICY "insights_arena_super_admin" ON insights_arena
  FOR ALL USING (is_super_admin());

CREATE POLICY "insights_arena_admin" ON insights_arena
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );

-- ============================================================
-- POLITICAS: CRON JOBS CONFIG (somente super admin)
-- ============================================================
CREATE POLICY "cron_jobs_config_super_admin" ON cron_jobs_config
  FOR ALL USING (is_super_admin());

-- ============================================================
-- POLITICAS: AUTOMACOES (tabela renomeada de automacoes_n8n)
-- Atualizar nome das policies existentes nao e necessario
-- pois foram criadas com nomes genericos, mas os RLS
-- continuam funcionando pois a tabela foi apenas renomeada
-- ============================================================

-- ============================================================
-- TRIGGERS: updated_at para novas tabelas
-- ============================================================
CREATE TRIGGER update_fila_mensagens_updated_at BEFORE UPDATE ON fila_mensagens
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chatbot_conversas_updated_at BEFORE UPDATE ON chatbot_conversas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_cron_jobs_config_updated_at BEFORE UPDATE ON cron_jobs_config
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- INDEXES: Novas tabelas
-- ============================================================

-- fila_mensagens
CREATE INDEX idx_fila_mensagens_status ON fila_mensagens(status, agendado_para)
  WHERE status IN ('pendente', 'erro');
CREATE INDEX idx_fila_mensagens_arena ON fila_mensagens(arena_id, created_at);
CREATE INDEX idx_fila_mensagens_canal ON fila_mensagens(canal, status);
CREATE INDEX idx_fila_mensagens_prioridade ON fila_mensagens(prioridade, agendado_para)
  WHERE status = 'pendente';

-- chatbot_conversas
CREATE INDEX idx_chatbot_conversas_arena ON chatbot_conversas(arena_id, status);
CREATE INDEX idx_chatbot_conversas_telefone ON chatbot_conversas(telefone_cliente, arena_id);
CREATE INDEX idx_chatbot_conversas_escalado ON chatbot_conversas(escalado_para_humano)
  WHERE escalado_para_humano = true;

-- chatbot_mensagens
CREATE INDEX idx_chatbot_mensagens_conversa ON chatbot_mensagens(conversa_id, created_at);

-- insights_arena
CREATE INDEX idx_insights_arena_arena ON insights_arena(arena_id, created_at);
CREATE INDEX idx_insights_arena_nao_lido ON insights_arena(arena_id, lido)
  WHERE lido = false;

-- automacoes (tabela renomeada)
CREATE INDEX IF NOT EXISTS idx_automacoes_edge_function ON automacoes(edge_function_name)
  WHERE ativo = true;

-- logs_execucao (novos campos)
CREATE INDEX IF NOT EXISTS idx_logs_execucao_arena ON logs_execucao(arena_id, data_execucao);
CREATE INDEX IF NOT EXISTS idx_logs_execucao_edge ON logs_execucao(edge_function, data_execucao);

