-- ============================================================================
-- MIGRATION 012: Row Level Security (RLS) Policies
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Base: Legacy v1.0 (granular per role com SELECT vs ALL)
-- //HIGH-RISK - seguranca de acesso a dados
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- HABILITAR RLS EM TODAS AS TABELAS
-- ============================================================

-- Platform tables
ALTER TABLE planos_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE modulos_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE arenas_planos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faturas_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE arena_modulos ENABLE ROW LEVEL SECURITY;
ALTER TABLE relatorios_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE arena_relatorios_config ENABLE ROW LEVEL SECURITY;

-- Users tables
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE funcionarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissoes ENABLE ROW LEVEL SECURITY;

-- Courts tables
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras_bloqueios ENABLE ROW LEVEL SECURITY;
ALTER TABLE manutencoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE equipamentos_quadra ENABLE ROW LEVEL SECURITY;

-- Scheduling tables
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_espera ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos_recorrentes ENABLE ROW LEVEL SECURITY;

-- Classes tables
ALTER TABLE tipos_aula ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE matriculas_aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE reposicoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE planos_aula ENABLE ROW LEVEL SECURITY;
ALTER TABLE pacotes_aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_pacotes ENABLE ROW LEVEL SECURITY;

-- Financial tables
ALTER TABLE planos ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE comissoes_professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE detalhes_comissoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimentacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE formas_pagamento ENABLE ROW LEVEL SECURITY;

-- Tournaments tables
ALTER TABLE torneios ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscricoes_torneios ENABLE ROW LEVEL SECURITY;
ALTER TABLE chaveamento ENABLE ROW LEVEL SECURITY;
ALTER TABLE partidas_torneio ENABLE ROW LEVEL SECURITY;
ALTER TABLE resultados_torneio ENABLE ROW LEVEL SECURITY;
ALTER TABLE eventos ENABLE ROW LEVEL SECURITY;
ALTER TABLE participantes_eventos ENABLE ROW LEVEL SECURITY;

-- Communication tables
ALTER TABLE notificacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE campanhas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_comunicacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates_comunicacao ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates_whatsapp ENABLE ROW LEVEL SECURITY;
ALTER TABLE integracao_whatsapp ENABLE ROW LEVEL SECURITY;
ALTER TABLE integracao_asaas ENABLE ROW LEVEL SECURITY;
ALTER TABLE automacoes_n8n ENABLE ROW LEVEL SECURITY;
ALTER TABLE logs_execucao ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes_backup ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes_push ENABLE ROW LEVEL SECURITY;

-- Config and audit tables
ALTER TABLE configuracoes_arena ENABLE ROW LEVEL SECURITY;
ALTER TABLE politicas_negocio ENABLE ROW LEVEL SECURITY;
ALTER TABLE modulos_arena ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessoes_usuario ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE avaliacoes_performance ENABLE ROW LEVEL SECURITY;
ALTER TABLE evolucao_alunos ENABLE ROW LEVEL SECURITY;
ALTER TABLE relatorios_personalizados ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes_visibilidade ENABLE ROW LEVEL SECURITY;
ALTER TABLE logs_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE auditoria_dados ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracoes ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- HELPER: funcao para obter arena_id do usuario autenticado
-- Evita subqueries repetidas em todas as policies
-- ============================================================
CREATE OR REPLACE FUNCTION auth_user_arena_id()
RETURNS UUID AS $$
  SELECT arena_id FROM usuarios WHERE auth_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth_user_role()
RETURNS user_role AS $$
  SELECT tipo_usuario FROM usuarios WHERE auth_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION auth_user_id()
RETURNS UUID AS $$
  SELECT id FROM usuarios WHERE auth_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM usuarios
    WHERE auth_id = auth.uid()
    AND tipo_usuario = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;


-- ============================================================
-- POLITICAS: PLANOS DO SISTEMA (somente leitura para todos, gerencia super_admin)
-- ============================================================
CREATE POLICY "planos_sistema_read_all" ON planos_sistema
  FOR SELECT USING (true);

CREATE POLICY "planos_sistema_manage_super_admin" ON planos_sistema
  FOR ALL USING (is_super_admin());

-- ============================================================
-- POLITICAS: MODULOS DO SISTEMA (somente leitura para todos, gerencia super_admin)
-- ============================================================
CREATE POLICY "modulos_sistema_read_all" ON modulos_sistema
  FOR SELECT USING (true);

CREATE POLICY "modulos_sistema_manage_super_admin" ON modulos_sistema
  FOR ALL USING (is_super_admin());

-- ============================================================
-- POLITICAS: RELATORIOS DO SISTEMA
-- ============================================================
CREATE POLICY "relatorios_sistema_read_all" ON relatorios_sistema
  FOR SELECT USING (true);

CREATE POLICY "relatorios_sistema_manage_super_admin" ON relatorios_sistema
  FOR ALL USING (is_super_admin());

-- ============================================================
-- POLITICAS: ARENAS
-- ============================================================
CREATE POLICY "Super admins can manage all arenas" ON arenas
  FOR ALL USING (is_super_admin());

CREATE POLICY "Users can view own arena" ON arenas
  FOR SELECT USING (
    id = auth_user_arena_id()
  );

-- ============================================================
-- POLITICAS: ARENAS_PLANOS
-- ============================================================
CREATE POLICY "arenas_planos_super_admin" ON arenas_planos
  FOR ALL USING (is_super_admin());

CREATE POLICY "arenas_planos_arena_view" ON arenas_planos
  FOR SELECT USING (arena_id = auth_user_arena_id());

-- ============================================================
-- POLITICAS: FATURAS DO SISTEMA
-- ============================================================
CREATE POLICY "faturas_sistema_super_admin" ON faturas_sistema
  FOR ALL USING (is_super_admin());

CREATE POLICY "faturas_sistema_arena_admin_view" ON faturas_sistema
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );

-- ============================================================
-- POLITICAS: ARENA_MODULOS
-- ============================================================
CREATE POLICY "arena_modulos_super_admin" ON arena_modulos
  FOR ALL USING (is_super_admin());

CREATE POLICY "arena_modulos_arena_view" ON arena_modulos
  FOR SELECT USING (arena_id = auth_user_arena_id());

-- ============================================================
-- POLITICAS: ARENA_RELATORIOS_CONFIG
-- ============================================================
CREATE POLICY "arena_relatorios_config_super_admin" ON arena_relatorios_config
  FOR ALL USING (is_super_admin());

CREATE POLICY "arena_relatorios_config_admin_manage" ON arena_relatorios_config
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() = 'arena_admin'
  );

CREATE POLICY "arena_relatorios_config_staff_view" ON arena_relatorios_config
  FOR SELECT USING (arena_id = auth_user_arena_id());

-- ============================================================
-- POLITICAS: USUARIOS
-- ============================================================
CREATE POLICY "Users can view users from same arena" ON usuarios
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "Arena admins can manage users" ON usuarios
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "Users can update own profile" ON usuarios
  FOR UPDATE USING (auth_id = auth.uid())
  WITH CHECK (auth_id = auth.uid());

-- ============================================================
-- POLITICAS: PROFESSORES
-- ============================================================
CREATE POLICY "professores_arena_view" ON professores
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = professores.usuario_id
      AND u.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "professores_admin_manage" ON professores
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = professores.usuario_id
      AND u.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "professores_self_update" ON professores
  FOR UPDATE USING (
    usuario_id = auth_user_id()
  );

-- ============================================================
-- POLITICAS: FUNCIONARIOS
-- ============================================================
CREATE POLICY "funcionarios_admin_manage" ON funcionarios
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = funcionarios.usuario_id
      AND u.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "funcionarios_self_view" ON funcionarios
  FOR SELECT USING (
    usuario_id = auth_user_id()
  );

-- ============================================================
-- POLITICAS: PERMISSOES
-- ============================================================
CREATE POLICY "permissoes_admin_manage" ON permissoes
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM usuarios u
      WHERE u.id = permissoes.usuario_id
      AND u.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "permissoes_self_view" ON permissoes
  FOR SELECT USING (
    usuario_id = auth_user_id()
  );

-- ============================================================
-- POLITICAS: QUADRAS
-- ============================================================
CREATE POLICY "Users can view quadras from same arena" ON quadras
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "Staff can manage quadras" ON quadras
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: QUADRAS_BLOQUEIOS
-- ============================================================
CREATE POLICY "quadras_bloqueios_arena_view" ON quadras_bloqueios
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = quadras_bloqueios.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "quadras_bloqueios_staff_manage" ON quadras_bloqueios
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = quadras_bloqueios.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: MANUTENCOES
-- ============================================================
CREATE POLICY "manutencoes_arena_view" ON manutencoes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = manutencoes.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "manutencoes_staff_manage" ON manutencoes
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = manutencoes.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: EQUIPAMENTOS_QUADRA
-- ============================================================
CREATE POLICY "equipamentos_arena_view" ON equipamentos_quadra
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = equipamentos_quadra.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "equipamentos_staff_manage" ON equipamentos_quadra
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM quadras q
      WHERE q.id = equipamentos_quadra.quadra_id
      AND q.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: AGENDAMENTOS
-- ============================================================
CREATE POLICY "Users can view agendamentos from same arena" ON agendamentos
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "Users can create own agendamentos" ON agendamentos
  FOR INSERT WITH CHECK (
    arena_id = auth_user_arena_id()
    AND cliente_principal_id = auth_user_id()
  );

CREATE POLICY "Users can update own agendamentos" ON agendamentos
  FOR UPDATE USING (
    cliente_principal_id = auth_user_id()
    AND arena_id = auth_user_arena_id()
  );

CREATE POLICY "Staff can manage all agendamentos" ON agendamentos
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: CHECKINS
-- ============================================================
CREATE POLICY "checkins_arena_view" ON checkins
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM agendamentos a
      WHERE a.id = checkins.agendamento_id
      AND a.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "checkins_staff_manage" ON checkins
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM agendamentos a
      WHERE a.id = checkins.agendamento_id
      AND a.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario', 'professor')
    OR is_super_admin()
  );

CREATE POLICY "checkins_self_create" ON checkins
  FOR INSERT WITH CHECK (
    usuario_id = auth_user_id()
  );

-- ============================================================
-- POLITICAS: LISTA DE ESPERA
-- ============================================================
CREATE POLICY "lista_espera_arena_view" ON lista_espera
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "lista_espera_self_manage" ON lista_espera
  FOR ALL USING (
    cliente_id = auth_user_id()
    AND arena_id = auth_user_arena_id()
  );

CREATE POLICY "lista_espera_staff_manage" ON lista_espera
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: AGENDAMENTOS RECORRENTES
-- ============================================================
CREATE POLICY "agendamentos_recorrentes_arena_view" ON agendamentos_recorrentes
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "agendamentos_recorrentes_staff_manage" ON agendamentos_recorrentes
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: TIPOS DE AULA
-- ============================================================
CREATE POLICY "tipos_aula_arena_view" ON tipos_aula
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "tipos_aula_admin_manage" ON tipos_aula
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: AULAS
-- ============================================================
CREATE POLICY "Users can view aulas from same arena" ON aulas
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "Professors can manage own aulas" ON aulas
  FOR ALL USING (
    professor_id IN (
      SELECT p.id FROM professores p
      JOIN usuarios u ON p.usuario_id = u.id
      WHERE u.auth_id = auth.uid()
    )
  );

CREATE POLICY "Staff can manage all aulas" ON aulas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: MATRICULAS EM AULAS
-- ============================================================
CREATE POLICY "matriculas_aulas_arena_view" ON matriculas_aulas
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM aulas a
      WHERE a.id = matriculas_aulas.aula_id
      AND a.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "matriculas_aulas_self_view" ON matriculas_aulas
  FOR SELECT USING (
    aluno_id = auth_user_id()
  );

CREATE POLICY "matriculas_aulas_staff_manage" ON matriculas_aulas
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM aulas a
      WHERE a.id = matriculas_aulas.aula_id
      AND a.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario', 'professor')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: REPOSICOES
-- ============================================================
CREATE POLICY "reposicoes_arena_view" ON reposicoes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM matriculas_aulas ma
      JOIN aulas a ON a.id = ma.aula_id
      WHERE ma.id = reposicoes.matricula_original_id
      AND a.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "reposicoes_staff_manage" ON reposicoes
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario', 'professor')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: PLANOS DE AULA
-- ============================================================
CREATE POLICY "planos_aula_professor_manage" ON planos_aula
  FOR ALL USING (
    professor_id IN (
      SELECT p.id FROM professores p
      JOIN usuarios u ON p.usuario_id = u.id
      WHERE u.auth_id = auth.uid()
    )
    OR is_super_admin()
  );

CREATE POLICY "planos_aula_admin_view" ON planos_aula
  FOR SELECT USING (
    auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: PACOTES DE AULAS
-- ============================================================
CREATE POLICY "pacotes_aulas_arena_view" ON pacotes_aulas
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "pacotes_aulas_admin_manage" ON pacotes_aulas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: COMPRAS DE PACOTES
-- ============================================================
CREATE POLICY "compras_pacotes_self_view" ON compras_pacotes
  FOR SELECT USING (
    aluno_id = auth_user_id()
    OR is_super_admin()
  );

CREATE POLICY "compras_pacotes_staff_manage" ON compras_pacotes
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: PLANOS (mensalidades da arena)
-- ============================================================
CREATE POLICY "planos_arena_view" ON planos
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "planos_admin_manage" ON planos
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: CONTRATOS
-- ============================================================
CREATE POLICY "contratos_arena_view" ON contratos
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "contratos_self_view" ON contratos
  FOR SELECT USING (
    cliente_id = auth_user_id()
  );

CREATE POLICY "contratos_admin_manage" ON contratos
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: FATURAS
-- ============================================================
CREATE POLICY "Users can view own faturas" ON faturas
  FOR SELECT USING (
    cliente_id = auth_user_id()
  );

CREATE POLICY "Staff can view arena faturas" ON faturas
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

CREATE POLICY "Staff can manage faturas" ON faturas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: COMISSOES DE PROFESSORES
-- ============================================================
CREATE POLICY "comissoes_professor_self_view" ON comissoes_professores
  FOR SELECT USING (
    professor_id IN (
      SELECT p.id FROM professores p
      JOIN usuarios u ON p.usuario_id = u.id
      WHERE u.auth_id = auth.uid()
    )
    OR is_super_admin()
  );

CREATE POLICY "comissoes_admin_manage" ON comissoes_professores
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: DETALHES DAS COMISSOES
-- ============================================================
CREATE POLICY "detalhes_comissoes_view" ON detalhes_comissoes
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM comissoes_professores cp
      WHERE cp.id = detalhes_comissoes.comissao_id
      AND (
        cp.arena_id = auth_user_arena_id()
        OR cp.professor_id IN (
          SELECT p.id FROM professores p
          JOIN usuarios u ON p.usuario_id = u.id
          WHERE u.auth_id = auth.uid()
        )
      )
    )
    OR is_super_admin()
  );

CREATE POLICY "detalhes_comissoes_admin_manage" ON detalhes_comissoes
  FOR ALL USING (
    auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: MOVIMENTACOES
-- ============================================================
CREATE POLICY "movimentacoes_arena_view" ON movimentacoes
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

CREATE POLICY "movimentacoes_admin_manage" ON movimentacoes
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: FORMAS DE PAGAMENTO
-- ============================================================
CREATE POLICY "formas_pagamento_arena_view" ON formas_pagamento
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "formas_pagamento_admin_manage" ON formas_pagamento
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: TORNEIOS
-- ============================================================
CREATE POLICY "Users can view torneios from same arena" ON torneios
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "Staff can manage torneios" ON torneios
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: INSCRICOES EM TORNEIOS
-- ============================================================
CREATE POLICY "inscricoes_torneios_arena_view" ON inscricoes_torneios
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM torneios t
      WHERE t.id = inscricoes_torneios.torneio_id
      AND t.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "inscricoes_torneios_self_create" ON inscricoes_torneios
  FOR INSERT WITH CHECK (
    jogador1_id = auth_user_id()
    OR jogador2_id = auth_user_id()
  );

CREATE POLICY "inscricoes_torneios_staff_manage" ON inscricoes_torneios
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM torneios t
      WHERE t.id = inscricoes_torneios.torneio_id
      AND t.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: CHAVEAMENTO
-- ============================================================
CREATE POLICY "chaveamento_arena_view" ON chaveamento
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM torneios t
      WHERE t.id = chaveamento.torneio_id
      AND t.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "chaveamento_staff_manage" ON chaveamento
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: PARTIDAS DO TORNEIO
-- ============================================================
CREATE POLICY "partidas_torneio_arena_view" ON partidas_torneio
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM torneios t
      WHERE t.id = partidas_torneio.torneio_id
      AND t.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "partidas_torneio_staff_manage" ON partidas_torneio
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: RESULTADOS DO TORNEIO
-- ============================================================
CREATE POLICY "resultados_torneio_arena_view" ON resultados_torneio
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM torneios t
      WHERE t.id = resultados_torneio.torneio_id
      AND t.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "resultados_torneio_staff_manage" ON resultados_torneio
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: EVENTOS
-- ============================================================
CREATE POLICY "eventos_arena_view" ON eventos
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "eventos_staff_manage" ON eventos
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: PARTICIPANTES DE EVENTOS
-- ============================================================
CREATE POLICY "participantes_eventos_arena_view" ON participantes_eventos
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM eventos e
      WHERE e.id = participantes_eventos.evento_id
      AND e.arena_id = auth_user_arena_id()
    )
    OR is_super_admin()
  );

CREATE POLICY "participantes_eventos_self_create" ON participantes_eventos
  FOR INSERT WITH CHECK (
    participante_id = auth_user_id()
  );

CREATE POLICY "participantes_eventos_staff_manage" ON participantes_eventos
  FOR ALL USING (
    auth_user_role() IN ('arena_admin', 'funcionario')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: NOTIFICACOES
-- ============================================================
CREATE POLICY "Users can view own notifications" ON notificacoes
  FOR SELECT USING (
    usuario_destinatario_id = auth_user_id()
  );

CREATE POLICY "Users can update own notifications" ON notificacoes
  FOR UPDATE USING (
    usuario_destinatario_id = auth_user_id()
  );

CREATE POLICY "Staff can manage notifications" ON notificacoes
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: CAMPANHAS
-- ============================================================
CREATE POLICY "campanhas_admin_manage" ON campanhas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: HISTORICO DE COMUNICACOES
-- ============================================================
CREATE POLICY "historico_comunicacoes_self_view" ON historico_comunicacoes
  FOR SELECT USING (
    usuario_id = auth_user_id()
    OR is_super_admin()
  );

CREATE POLICY "historico_comunicacoes_admin_manage" ON historico_comunicacoes
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: TEMPLATES DE COMUNICACAO
-- ============================================================
CREATE POLICY "templates_comunicacao_arena_view" ON templates_comunicacao
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "templates_comunicacao_admin_manage" ON templates_comunicacao
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: TEMPLATES WHATSAPP
-- ============================================================
CREATE POLICY "templates_whatsapp_arena_view" ON templates_whatsapp
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "templates_whatsapp_admin_manage" ON templates_whatsapp
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: INTEGRACOES (whatsapp, asaas, n8n) - SOMENTE ADMIN
-- //HIGH-RISK - acesso a credenciais de integracao
-- ============================================================
CREATE POLICY "integracao_whatsapp_admin" ON integracao_whatsapp
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "integracao_asaas_admin" ON integracao_asaas
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "automacoes_n8n_admin" ON automacoes_n8n
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "logs_execucao_admin" ON logs_execucao
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM automacoes_n8n a
      WHERE a.id = logs_execucao.automacao_id
      AND a.arena_id = auth_user_arena_id()
    )
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

-- ============================================================
-- POLITICAS: CONFIGURACOES DE BACKUP E PUSH
-- ============================================================
CREATE POLICY "configuracoes_backup_admin" ON configuracoes_backup
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_push_admin_manage" ON configuracoes_push
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_push_arena_view" ON configuracoes_push
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
  );

-- ============================================================
-- POLITICAS: CONFIG E AUDIT TABLES
-- ============================================================
CREATE POLICY "configuracoes_arena_view" ON configuracoes_arena
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_arena_admin_manage" ON configuracoes_arena
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "politicas_negocio_arena_view" ON politicas_negocio
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "politicas_negocio_admin_manage" ON politicas_negocio
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "modulos_arena_view" ON modulos_arena
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "modulos_arena_admin_manage" ON modulos_arena
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "sessoes_usuario_self" ON sessoes_usuario
  FOR SELECT USING (
    usuario_id = auth_user_id()
    OR is_super_admin()
  );

CREATE POLICY "historico_atividades_arena_view" ON historico_atividades
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "historico_atividades_self_view" ON historico_atividades
  FOR SELECT USING (
    usuario_id = auth_user_id()
  );

CREATE POLICY "avaliacoes_performance_admin_manage" ON avaliacoes_performance
  FOR ALL USING (
    auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "avaliacoes_performance_self_view" ON avaliacoes_performance
  FOR SELECT USING (
    usuario_avaliado_id = auth_user_id()
    AND visivel_avaliado = true
  );

CREATE POLICY "evolucao_alunos_professor_manage" ON evolucao_alunos
  FOR ALL USING (
    professor_id IN (
      SELECT p.id FROM professores p
      JOIN usuarios u ON p.usuario_id = u.id
      WHERE u.auth_id = auth.uid()
    )
    OR auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "evolucao_alunos_self_view" ON evolucao_alunos
  FOR SELECT USING (
    aluno_id = auth_user_id()
    AND visivel_aluno = true
  );

CREATE POLICY "relatorios_personalizados_arena" ON relatorios_personalizados
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_visibilidade_admin" ON configuracoes_visibilidade
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_visibilidade_view" ON configuracoes_visibilidade
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
  );

CREATE POLICY "logs_sistema_admin" ON logs_sistema
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "auditoria_dados_admin" ON auditoria_dados
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_view" ON configuracoes
  FOR SELECT USING (
    arena_id = auth_user_arena_id()
    OR is_super_admin()
  );

CREATE POLICY "configuracoes_admin_manage" ON configuracoes
  FOR ALL USING (
    arena_id = auth_user_arena_id()
    AND auth_user_role() IN ('arena_admin')
    OR is_super_admin()
  );
