# Seguranca, RLS, Triggers e Indices

[<- Voltar ao Indice](../README.md) | [Schemas SQL](./schemas.md)

---

## Row Level Security (RLS)

### Ativacao

```sql
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aulas ENABLE ROW LEVEL SECURITY;
ALTER TABLE contratos ENABLE ROW LEVEL SECURITY;
ALTER TABLE faturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE torneios ENABLE ROW LEVEL SECURITY;
ALTER TABLE professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE funcionarios ENABLE ROW LEVEL SECURITY;
```

### Politicas

#### Super Admin (acesso total)
```sql
CREATE POLICY "super_admin_full_access" ON arenas
FOR ALL USING (
  auth.uid() IN (
    SELECT auth_id FROM usuarios
    WHERE tipo_usuario = 'super_admin'
  )
);
```

#### Isolamento de Tenant (padrao para todas as tabelas)
```sql
-- Usuarios so veem dados da propria arena
CREATE POLICY "tenant_isolation" ON usuarios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "agendamentos_tenant_isolation" ON agendamentos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "quadras_tenant_isolation" ON quadras
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "aulas_tenant_isolation" ON aulas
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "contratos_tenant_isolation" ON contratos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "faturas_tenant_isolation" ON faturas
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "torneios_tenant_isolation" ON torneios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "professores_tenant_isolation" ON professores
FOR ALL USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios
      WHERE auth_id = auth.uid()
    )
  )
);

CREATE POLICY "funcionarios_tenant_isolation" ON funcionarios
FOR ALL USING (
  usuario_id IN (
    SELECT id FROM usuarios
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios
      WHERE auth_id = auth.uid()
    )
  )
);
```

---

## Triggers e Funcoes

### Atualizacao automatica de updated_at

```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar em todas as tabelas com updated_at
CREATE TRIGGER update_arenas_updated_at BEFORE UPDATE ON arenas
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON usuarios
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quadras_updated_at BEFORE UPDATE ON quadras
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agendamentos_updated_at BEFORE UPDATE ON agendamentos
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### Auditoria automatica

```sql
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

-- Aplicar triggers de auditoria
CREATE TRIGGER audit_usuarios AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_agendamentos AFTER INSERT OR UPDATE OR DELETE ON agendamentos
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_contratos AFTER INSERT OR UPDATE OR DELETE ON contratos
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
```

---

## Indices para Performance

```sql
-- Tenant isolation
CREATE INDEX idx_usuarios_arena_id ON usuarios(arena_id);
CREATE INDEX idx_usuarios_auth_id ON usuarios(auth_id);
CREATE INDEX idx_agendamentos_arena_id ON agendamentos(arena_id);
CREATE INDEX idx_quadras_arena_id ON quadras(arena_id);

-- Consultas de agendamento
CREATE INDEX idx_agendamentos_data ON agendamentos(data_agendamento);
CREATE INDEX idx_agendamentos_quadra_data ON agendamentos(quadra_id, data_agendamento);
CREATE INDEX idx_agendamentos_cliente ON agendamentos(cliente_principal_id);
CREATE INDEX idx_agendamentos_status ON agendamentos(status);

-- Consultas financeiras
CREATE INDEX idx_faturas_vencimento ON faturas(data_vencimento);
CREATE INDEX idx_faturas_cliente ON faturas(cliente_id);
CREATE INDEX idx_faturas_status ON faturas(status);
CREATE INDEX idx_contratos_cliente ON contratos(cliente_id);
CREATE INDEX idx_movimentacoes_data ON movimentacoes_financeiras(data_movimentacao);

-- Auditoria e logs
CREATE INDEX idx_auditoria_tabela ON auditoria(tabela);
CREATE INDEX idx_auditoria_timestamp ON auditoria(timestamp_operacao);
CREATE INDEX idx_historico_usuario ON historico_atividades(usuario_id);
CREATE INDEX idx_historico_data ON historico_atividades(data_atividade);

-- Indices compostos
CREATE INDEX idx_agendamentos_arena_data_status ON agendamentos(arena_id, data_agendamento, status);
CREATE INDEX idx_usuarios_arena_tipo ON usuarios(arena_id, tipo_usuario);
CREATE INDEX idx_faturas_arena_status_vencimento ON faturas(arena_id, status, data_vencimento);
```

---

## Seeds (Dados Iniciais)

### Modulos do sistema
```sql
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
```

### Planos do sistema
```sql
INSERT INTO planos_sistema (nome, valor_mensal, max_quadras, max_usuarios, modulos_inclusos) VALUES
('Basico', 89.90, 5, 50, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos"]'),
('Pro', 189.90, 15, 200, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "comunicacao", "relatorios"]'),
('Premium', 389.90, 50, 1000, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "torneios", "comunicacao", "relatorios", "integracoes"]');
```

### Relatorios do sistema
```sql
INSERT INTO relatorios_sistema (nome, codigo, tipo, nivel_minimo, descricao) VALUES
('Ocupacao de Quadras', 'ocupacao_quadras', 'operacional', 'funcionario', 'Relatorio de ocupacao das quadras por periodo'),
('Receita Mensal', 'receita_mensal', 'financeiro', 'admin', 'Relatorio de receita mensal da arena'),
('Performance de Professores', 'performance_professores', 'performance', 'admin', 'Relatorio de performance dos professores'),
('Inadimplencia', 'inadimplencia', 'financeiro', 'admin', 'Relatorio de clientes inadimplentes'),
('Ranking de Alunos', 'ranking_alunos', 'performance', 'professor', 'Ranking e evolucao dos alunos');
```

---

**Proximos:** [Schemas SQL](./schemas.md) | [Modulos](../modules/)
