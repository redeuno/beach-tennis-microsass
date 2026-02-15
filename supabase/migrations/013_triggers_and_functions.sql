-- ============================================================================
-- MIGRATION 013: Triggers and Functions
-- Verana Beach Tennis - MicroSaaS Multi-tenant
-- Functions: update_updated_at_column, audit_trigger_function,
--            generate_invoice_number, apply_default_configurations
-- Base: Legacy v1.0 (SECURITY DEFINER, complete audit)
-- ============================================================================
-- //AI-GENERATED

-- ============================================================
-- FUNCAO: Atualizar updated_at automaticamente
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger de updated_at em TODAS as tabelas que possuem o campo
-- Platform tables
CREATE TRIGGER update_planos_sistema_updated_at BEFORE UPDATE ON planos_sistema
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_modulos_sistema_updated_at BEFORE UPDATE ON modulos_sistema
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_arenas_planos_updated_at BEFORE UPDATE ON arenas_planos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_faturas_sistema_updated_at BEFORE UPDATE ON faturas_sistema
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_arena_relatorios_config_updated_at BEFORE UPDATE ON arena_relatorios_config
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Users tables
CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_professores_updated_at BEFORE UPDATE ON professores
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_funcionarios_updated_at BEFORE UPDATE ON funcionarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Courts tables
CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_quadras_bloqueios_updated_at BEFORE UPDATE ON quadras_bloqueios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_manutencoes_updated_at BEFORE UPDATE ON manutencoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_equipamentos_quadra_updated_at BEFORE UPDATE ON equipamentos_quadra
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Scheduling tables
CREATE TRIGGER update_agendamentos_updated_at BEFORE UPDATE ON agendamentos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lista_espera_updated_at BEFORE UPDATE ON lista_espera
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_agendamentos_recorrentes_updated_at BEFORE UPDATE ON agendamentos_recorrentes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Classes tables
CREATE TRIGGER update_tipos_aula_updated_at BEFORE UPDATE ON tipos_aula
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_aulas_updated_at BEFORE UPDATE ON aulas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_matriculas_aulas_updated_at BEFORE UPDATE ON matriculas_aulas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reposicoes_updated_at BEFORE UPDATE ON reposicoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_planos_aula_updated_at BEFORE UPDATE ON planos_aula
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_pacotes_aulas_updated_at BEFORE UPDATE ON pacotes_aulas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_compras_pacotes_updated_at BEFORE UPDATE ON compras_pacotes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Financial tables
CREATE TRIGGER update_planos_updated_at BEFORE UPDATE ON planos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_contratos_updated_at BEFORE UPDATE ON contratos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_faturas_updated_at BEFORE UPDATE ON faturas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_comissoes_professores_updated_at BEFORE UPDATE ON comissoes_professores
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_movimentacoes_updated_at BEFORE UPDATE ON movimentacoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_formas_pagamento_updated_at BEFORE UPDATE ON formas_pagamento
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Tournaments tables
CREATE TRIGGER update_torneios_updated_at BEFORE UPDATE ON torneios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_inscricoes_torneios_updated_at BEFORE UPDATE ON inscricoes_torneios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chaveamento_updated_at BEFORE UPDATE ON chaveamento
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_partidas_torneio_updated_at BEFORE UPDATE ON partidas_torneio
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventos_updated_at BEFORE UPDATE ON eventos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_participantes_eventos_updated_at BEFORE UPDATE ON participantes_eventos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Communication tables
CREATE TRIGGER update_notificacoes_updated_at BEFORE UPDATE ON notificacoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_campanhas_updated_at BEFORE UPDATE ON campanhas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_templates_comunicacao_updated_at BEFORE UPDATE ON templates_comunicacao
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_templates_whatsapp_updated_at BEFORE UPDATE ON templates_whatsapp
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_integracao_whatsapp_updated_at BEFORE UPDATE ON integracao_whatsapp
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_integracao_asaas_updated_at BEFORE UPDATE ON integracao_asaas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_automacoes_n8n_updated_at BEFORE UPDATE ON automacoes_n8n
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_configuracoes_backup_updated_at BEFORE UPDATE ON configuracoes_backup
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_configuracoes_push_updated_at BEFORE UPDATE ON configuracoes_push
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Config tables
CREATE TRIGGER update_configuracoes_arena_updated_at BEFORE UPDATE ON configuracoes_arena
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_politicas_negocio_updated_at BEFORE UPDATE ON politicas_negocio
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_modulos_arena_updated_at BEFORE UPDATE ON modulos_arena
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_avaliacoes_performance_updated_at BEFORE UPDATE ON avaliacoes_performance
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_evolucao_alunos_updated_at BEFORE UPDATE ON evolucao_alunos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_relatorios_personalizados_updated_at BEFORE UPDATE ON relatorios_personalizados
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_configuracoes_visibilidade_updated_at BEFORE UPDATE ON configuracoes_visibilidade
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_configuracoes_updated_at BEFORE UPDATE ON configuracoes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- ============================================================
-- FUNCAO: Auditoria automatica (SECURITY DEFINER)
-- Registra INSERT, UPDATE, DELETE em auditoria_dados
-- ============================================================
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

-- Aplicar triggers de auditoria nas tabelas CRITICAS
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

CREATE TRIGGER audit_contratos AFTER INSERT OR UPDATE OR DELETE ON contratos
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_torneios AFTER INSERT OR UPDATE OR DELETE ON torneios
  FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();


-- ============================================================
-- FUNCAO: Gerar numero de fatura automaticamente
-- //HIGH-RISK - numeracao sequencial por arena
-- ============================================================
CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TRIGGER AS $$
DECLARE
  next_number INTEGER;
BEGIN
  -- So gera se numero_fatura nao foi fornecido
  IF NEW.numero_fatura IS NULL OR NEW.numero_fatura = '' THEN
    SELECT COALESCE(MAX(CAST(SUBSTRING(numero_fatura FROM '[0-9]+') AS INTEGER)), 0) + 1
    INTO next_number
    FROM faturas
    WHERE arena_id = NEW.arena_id;

    NEW.numero_fatura = LPAD(next_number::text, 6, '0');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_faturas_number BEFORE INSERT ON faturas
  FOR EACH ROW EXECUTE FUNCTION generate_invoice_number();


-- ============================================================
-- FUNCAO: Aplicar configuracoes padrao em novas arenas
-- Copia configuracoes do template (arena_id = UUID zero) para nova arena
-- ============================================================
CREATE OR REPLACE FUNCTION apply_default_configurations()
RETURNS TRIGGER AS $$
BEGIN
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

CREATE TRIGGER apply_default_config_trigger
  AFTER INSERT ON arenas
  FOR EACH ROW
  EXECUTE FUNCTION apply_default_configurations();
