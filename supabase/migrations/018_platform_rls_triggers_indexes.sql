-- ============================================================================
-- MIGRATION 018: RLS, Triggers e Indexes para tabelas da Migration 017
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- //HIGH-RISK - seguranca de acesso a novos dados
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- HABILITAR RLS NAS NOVAS TABELAS
-- ============================================================
ALTER TABLE usuarios_arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos_assinatura ENABLE ROW LEVEL SECURITY;
ALTER TABLE webhook_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE uso_plataforma ENABLE ROW LEVEL SECURITY;
ALTER TABLE anuncios_plataforma ENABLE ROW LEVEL SECURITY;
ALTER TABLE anuncios_lidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE metricas_plataforma ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- HELPER: funcao para verificar se usuario e proprietario da arena
-- Complementa as helpers existentes no 012 para multi-arena
-- ============================================================
CREATE OR REPLACE FUNCTION auth_user_arena_ids()
RETURNS SETOF UUID AS $$
  SELECT arena_id FROM usuarios_arenas
  WHERE usuario_id = auth_user_id()
  AND status = 'ativo';
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_arena_proprietario(p_arena_id UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM usuarios_arenas
    WHERE usuario_id = auth_user_id()
    AND arena_id = p_arena_id
    AND is_proprietario = true
    AND status = 'ativo'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ============================================================
-- POLITICAS: USUARIOS_ARENAS
-- ============================================================

-- Super admin ve tudo
CREATE POLICY "usuarios_arenas_super_admin" ON usuarios_arenas
  FOR ALL USING (is_super_admin());

-- Arena admin gerencia vinculos da propria arena
CREATE POLICY "usuarios_arenas_admin_manage" ON usuarios_arenas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
  );

-- Usuarios veem seus proprios vinculos
CREATE POLICY "usuarios_arenas_self_view" ON usuarios_arenas
  FOR SELECT USING (
    usuario_id = auth_user_id()
  );

-- Usuarios da mesma arena podem ver vinculos
CREATE POLICY "usuarios_arenas_arena_view" ON usuarios_arenas
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
  );


-- ============================================================
-- POLITICAS: EVENTOS_ASSINATURA
-- ============================================================
CREATE POLICY "eventos_assinatura_super_admin" ON eventos_assinatura
  FOR ALL USING (is_super_admin());

CREATE POLICY "eventos_assinatura_arena_admin_view" ON eventos_assinatura
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );


-- ============================================================
-- POLITICAS: WEBHOOK_EVENTS (somente super admin e sistema)
-- //HIGH-RISK
-- ============================================================
CREATE POLICY "webhook_events_super_admin" ON webhook_events
  FOR ALL USING (is_super_admin());

CREATE POLICY "webhook_events_arena_admin_view" ON webhook_events
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );


-- ============================================================
-- POLITICAS: USO_PLATAFORMA
-- ============================================================
CREATE POLICY "uso_plataforma_super_admin" ON uso_plataforma
  FOR ALL USING (is_super_admin());

CREATE POLICY "uso_plataforma_arena_admin_view" ON uso_plataforma
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );


-- ============================================================
-- POLITICAS: ANUNCIOS_PLATAFORMA
-- ============================================================
CREATE POLICY "anuncios_plataforma_super_admin" ON anuncios_plataforma
  FOR ALL USING (is_super_admin());

-- Todos podem ler anuncios ativos
CREATE POLICY "anuncios_plataforma_read_active" ON anuncios_plataforma
  FOR SELECT USING (
    ativo = true
    AND data_inicio <= NOW()
    AND (data_fim IS NULL OR data_fim >= NOW())
  );


-- ============================================================
-- POLITICAS: ANUNCIOS_LIDOS
-- ============================================================
CREATE POLICY "anuncios_lidos_super_admin" ON anuncios_lidos
  FOR ALL USING (is_super_admin());

CREATE POLICY "anuncios_lidos_self" ON anuncios_lidos
  FOR ALL USING (
    usuario_id = auth_user_id()
  );


-- ============================================================
-- POLITICAS: METRICAS_PLATAFORMA (somente super admin)
-- //HIGH-RISK
-- ============================================================
CREATE POLICY "metricas_plataforma_super_admin" ON metricas_plataforma
  FOR ALL USING (is_super_admin());


-- ============================================================
-- TRIGGERS: updated_at para novas tabelas
-- ============================================================
CREATE TRIGGER update_usuarios_arenas_updated_at BEFORE UPDATE ON usuarios_arenas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_webhook_events_updated_at BEFORE UPDATE ON webhook_events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_uso_plataforma_updated_at BEFORE UPDATE ON uso_plataforma
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_anuncios_plataforma_updated_at BEFORE UPDATE ON anuncios_plataforma
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- ============================================================
-- TRIGGERS: Auditoria para tabelas criticas
-- ============================================================
CREATE TRIGGER audit_eventos_assinatura AFTER INSERT OR UPDATE OR DELETE ON eventos_assinatura
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_webhook_events AFTER INSERT OR UPDATE OR DELETE ON webhook_events
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();


-- ============================================================
-- INDEXES: Novas tabelas
-- ============================================================

-- usuarios_arenas
CREATE INDEX idx_usuarios_arenas_usuario ON usuarios_arenas(usuario_id);
CREATE INDEX idx_usuarios_arenas_arena ON usuarios_arenas(arena_id);
CREATE INDEX idx_usuarios_arenas_usuario_ativa ON usuarios_arenas(usuario_id, arena_ativa) WHERE arena_ativa = true;
CREATE INDEX idx_usuarios_arenas_proprietario ON usuarios_arenas(arena_id, is_proprietario) WHERE is_proprietario = true;

-- eventos_assinatura
CREATE INDEX idx_eventos_assinatura_arena ON eventos_assinatura(arena_id, created_at);
CREATE INDEX idx_eventos_assinatura_tipo ON eventos_assinatura(tipo, created_at);

-- webhook_events
CREATE INDEX idx_webhook_events_provider ON webhook_events(provider, created_at);
CREATE INDEX idx_webhook_events_status ON webhook_events(status);
CREATE INDEX idx_webhook_events_external_id ON webhook_events(external_id);
CREATE INDEX idx_webhook_events_arena ON webhook_events(arena_id, created_at);

-- uso_plataforma
CREATE INDEX idx_uso_plataforma_arena_periodo ON uso_plataforma(arena_id, periodo);

-- anuncios_plataforma
CREATE INDEX idx_anuncios_plataforma_ativo ON anuncios_plataforma(ativo, data_inicio, data_fim);
CREATE INDEX idx_anuncios_plataforma_tipo ON anuncios_plataforma(tipo, ativo);

-- anuncios_lidos
CREATE INDEX idx_anuncios_lidos_usuario ON anuncios_lidos(usuario_id);

-- metricas_plataforma
CREATE INDEX idx_metricas_plataforma_data ON metricas_plataforma(data_referencia);

-- arenas (novos campos)
CREATE INDEX idx_arenas_status_assinatura ON arenas(status_assinatura);
CREATE INDEX idx_arenas_trial ON arenas(is_trial) WHERE is_trial = true;
CREATE INDEX idx_arenas_subdomain ON arenas(subdomain) WHERE subdomain IS NOT NULL;
CREATE INDEX idx_arenas_inadimplente ON arenas(dias_inadimplente) WHERE dias_inadimplente > 0;

