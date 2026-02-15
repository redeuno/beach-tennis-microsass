# Schemas SQL - Banco de Dados

[<- Voltar ao Indice](../README.md) | [Seguranca e RLS](./rls-and-security.md)

---

## Visao Geral

- **Engine:** PostgreSQL (Supabase)
- **Isolamento:** Multi-tenant via `arena_id` + RLS
- **Extensoes:** uuid-ossp, pgcrypto, postgis
- **Timezone:** America/Sao_Paulo
- **Total de tabelas:** ~60
- **Total de ENUMs:** ~50
- **Total de views:** 5

---

## Arquivos SQL Definitivos

Os schemas SQL executaveis estao em **`supabase/migrations/`**, organizados em 16 arquivos sequenciais.

**Para executar, siga o guia:** [`supabase/GUIA_EXECUCAO.md`](../../supabase/GUIA_EXECUCAO.md)

### Ordem de Execucao

| # | Arquivo | Conteudo |
|---|---------|----------|
| 1 | `001_extensions_and_config.sql` | Extensoes PostgreSQL + timezone + RLS global |
| 2 | `002_enums.sql` | ~50 tipos ENUM personalizados |
| 3 | `003_platform_tables.sql` | planos_sistema, modulos_sistema, arenas, arenas_planos, faturas_sistema, arena_modulos, relatorios_sistema, arena_relatorios_config |
| 4 | `004_users_tables.sql` | usuarios, professores, funcionarios, permissoes |
| 5 | `005_courts_tables.sql` | quadras, quadras_bloqueios, manutencoes, equipamentos_quadra |
| 6 | `006_scheduling_tables.sql` | agendamentos (com GENERATED columns), checkins, lista_espera, agendamentos_recorrentes |
| 7 | `007_classes_tables.sql` | tipos_aula, aulas, matriculas_aulas, reposicoes, planos_aula, pacotes_aulas, compras_pacotes |
| 8 | `008_financial_tables.sql` | planos, contratos (com GENERATED columns), faturas (com GENERATED columns), comissoes_professores, detalhes_comissoes, movimentacoes, formas_pagamento |
| 9 | `009_tournaments_tables.sql` | torneios, inscricoes_torneios, chaveamento, partidas_torneio, resultados_torneio, eventos, participantes_eventos |
| 10 | `010_communication_tables.sql` | notificacoes, campanhas, historico_comunicacoes, templates_comunicacao, templates_whatsapp, integracao_whatsapp, integracao_asaas, automacoes_n8n, logs_execucao, configuracoes_backup, configuracoes_push |
| 11 | `011_config_and_audit_tables.sql` | configuracoes_arena, politicas_negocio, modulos_arena, sessoes_usuario, historico_atividades, avaliacoes_performance, evolucao_alunos, relatorios_personalizados, configuracoes_visibilidade, logs_sistema, auditoria_dados, configuracoes |
| 12 | `012_rls_policies.sql` | Enable RLS em TODAS as tabelas + politicas granulares por role (super_admin, arena_admin, funcionario, professor, aluno) |
| 13 | `013_triggers_and_functions.sql` | update_updated_at, audit_trigger_function, generate_invoice_number, apply_default_configurations |
| 14 | `014_indexes.sql` | Indices otimizados para consultas frequentes |
| 15 | `015_views.sql` | vw_ocupacao_quadras, vw_receita_mensal, vw_performance_professores, vw_estatisticas_alunos, vw_dashboard_resumo |
| 16 | `016_seeds.sql` | Dados iniciais: modulos, planos (R$39.90/89.90/159.90), relatorios, configuracoes padrao |

---

## Decisoes Arquiteturais

### Base: Legacy v1.0 + v2.0 Melhorias

Os schemas definitivos usam o **Legacy v1.0** (`supabase-schemas-complete.md`, ~60 tabelas) como base, incorporando melhorias seletivas do v2.0:

| Aspecto | Fonte | Justificativa |
|---------|-------|---------------|
| ENUMs | v1.0 base + v2.0 valores expandidos | Type safety maxima |
| Tabelas de torneio | v1.0 (chaveamento, partidas, resultados) | Estavam ausentes no v2.0 |
| Tabelas de comunicacao | v1.0 (notificacoes, campanhas, templates, integracoes) | Estavam ausentes no v2.0 |
| GENERATED columns | v2.0 (duracao_minutos, valor_final, valor_final_mensalidade) | Colunas computadas automaticamente |
| modulos_sistema / arena_modulos | v2.0 | Controle granular de modulos por arena |
| relatorios_sistema / arena_relatorios_config | v2.0 | Configuracao de visibilidade de relatorios |
| RLS | v1.0 granular per role | Seguranca por papel (nao apenas tenant isolation) |
| FK aulas.professor_id | v1.0 -> professores(id) | Garante que so professores ministram aulas |
| Precos dos planos | v1.0 (R$39.90/89.90/159.90) | Precos mais acessiveis para mercado brasileiro |

### Padrao de Extensao (Extension Tables)

Professores e funcionarios sao **tabelas de extensao** de usuarios:
- `professores` referencia `usuarios(id)` via `usuario_id`
- `funcionarios` referencia `usuarios(id)` via `usuario_id`
- Dados comuns ficam em `usuarios`, dados especificos nas tabelas de extensao

---

## Validacao Pos-Execucao

```sql
-- Verificar total de tabelas (esperado: ~60+)
SELECT COUNT(*) FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- Verificar RLS habilitado
SELECT tablename, rowsecurity FROM pg_tables
WHERE schemaname = 'public' ORDER BY tablename;

-- Verificar triggers
SELECT trigger_name, event_object_table
FROM information_schema.triggers WHERE trigger_schema = 'public';

-- Verificar views
SELECT table_name FROM information_schema.views
WHERE table_schema = 'public';
```

---

**Proximos:** [Seguranca e RLS](./rls-and-security.md) | [Guia de Execucao](../../supabase/GUIA_EXECUCAO.md)
