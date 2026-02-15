# Schemas SQL - Banco de Dados

[<- Voltar ao Indice](../README.md) | [Seguranca e RLS](./rls-and-security.md)

---

## Visao Geral

- **Engine:** PostgreSQL (Supabase)
- **Isolamento:** Multi-tenant via `arena_id` + RLS
- **Extensoes:** uuid-ossp, pgcrypto, postgis
- **Timezone:** America/Sao_Paulo
- **Total de tabelas:** 71 (64 base + 7 novas plataforma)
- **Total de ENUMs:** 65 (59 base + 6 novos plataforma)
- **Total de views:** 5
- **Total de policies RLS:** ~110

---

## Arquivos SQL Definitivos

Os schemas SQL executaveis estao em **`supabase/migrations/`**, organizados em 18 arquivos sequenciais.

**Para executar, siga o guia:** [`supabase/GUIA_EXECUCAO.md`](../../supabase/GUIA_EXECUCAO.md)

### Ordem de Execucao

| # | Arquivo | Conteudo |
|---|---------|----------|
| 1 | `001_extensions_and_config.sql` | Extensoes PostgreSQL + timezone + RLS global |
| 2 | `002_enums.sql` | 59 tipos ENUM personalizados |
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
| 17 | `017_platform_enhancements.sql` | **NOVO** - Multi-arena, trial/assinatura, webhooks, metricas, anuncios, uso |
| 18 | `018_platform_rls_triggers_indexes.sql` | **NOVO** - RLS + triggers + indexes para tabelas do 017 |

---

## Tabelas por Modulo

### Plataforma (003 + 017) — 15 tabelas
| Tabela | Descricao |
|--------|-----------|
| planos_sistema | Planos de assinatura da plataforma |
| modulos_sistema | Catalogo de modulos disponiveis |
| arenas | Tenants do sistema (agora com campos de trial/assinatura/white-label) |
| arenas_planos | Historico de planos contratados |
| faturas_sistema | Cobranca da plataforma para arenas |
| arena_modulos | Modulos liberados por arena |
| relatorios_sistema | Catalogo de relatorios |
| arena_relatorios_config | Visibilidade de relatorios por arena |
| usuarios_arenas | **NOVO** - Vinculo usuario-arena (multi-arena) |
| eventos_assinatura | **NOVO** - Ciclo de vida da assinatura |
| webhook_events | **NOVO** - Log de webhooks recebidos |
| uso_plataforma | **NOVO** - Tracking de uso por arena |
| anuncios_plataforma | **NOVO** - Comunicacao plataforma -> arenas |
| anuncios_lidos | **NOVO** - Tracking de leitura de anuncios |
| metricas_plataforma | **NOVO** - Snapshot diario MRR/ARR/churn |

### Usuarios (004) — 4 tabelas
| Tabela | Descricao |
|--------|-----------|
| usuarios | Tabela principal de todos os usuarios |
| professores | Extensao de usuarios para professores |
| funcionarios | Extensao de usuarios para funcionarios |
| permissoes | Controle granular de permissoes |

### Quadras (005) — 4 tabelas
| Tabela | Descricao |
|--------|-----------|
| quadras | Quadras de cada arena |
| quadras_bloqueios | Bloqueios temporarios |
| manutencoes | Registros de manutencao |
| equipamentos_quadra | Inventario de equipamentos |

### Agendamentos (006) — 4 tabelas
| Tabela | Descricao |
|--------|-----------|
| agendamentos | Reservas (GENERATED: duracao_minutos, valor_final) |
| checkins | Registro de presenca |
| lista_espera | Fila de espera |
| agendamentos_recorrentes | Agendamentos fixos semanais |

### Aulas (007) — 7 tabelas
| Tabela | Descricao |
|--------|-----------|
| tipos_aula | Categorias de aula |
| aulas | Aulas agendadas |
| matriculas_aulas | Alunos matriculados |
| reposicoes | Controle de reposicao |
| planos_aula | Planejamento pedagogico |
| pacotes_aulas | Pacotes avulsos de aulas |
| compras_pacotes | Compras de pacotes por alunos |

### Financeiro (008) — 7 tabelas
| Tabela | Descricao |
|--------|-----------|
| planos | Planos de mensalidade da arena |
| contratos | Contratos com alunos (GENERATED: valor_final_mensalidade) |
| faturas | Faturas geradas (GENERATED: valor_total) |
| comissoes_professores | Periodo de comissao |
| detalhes_comissoes | Itens de comissao |
| movimentacoes | Fluxo de caixa |
| formas_pagamento | Formas aceitas por arena |

### Torneios (009) — 7 tabelas
| Tabela | Descricao |
|--------|-----------|
| torneios | Torneios organizados |
| inscricoes_torneios | Inscricoes de jogadores/duplas |
| chaveamento | Estrutura das chaves |
| partidas_torneio | Partidas do torneio |
| resultados_torneio | Resultados finais |
| eventos | Eventos especiais |
| participantes_eventos | Participantes de eventos |

### Comunicacao (010) — 11 tabelas
| Tabela | Descricao |
|--------|-----------|
| notificacoes | Notificacoes para usuarios |
| campanhas | Campanhas de marketing |
| historico_comunicacoes | Log de todas as comunicacoes |
| templates_comunicacao | Templates gerais |
| templates_whatsapp | Templates de WhatsApp |
| integracao_whatsapp | Config do Evolution API |
| integracao_asaas | Config do Asaas |
| automacoes_n8n | Automacoes configuradas |
| logs_execucao | Logs de automacoes |
| configuracoes_backup | Config de backup |
| configuracoes_push | Config de push notifications |

### Config e Auditoria (011) — 12 tabelas
| Tabela | Descricao |
|--------|-----------|
| configuracoes_arena | Configuracoes por arena |
| politicas_negocio | Regras de negocio |
| modulos_arena | Modulos ativos por arena |
| sessoes_usuario | Sessoes ativas |
| historico_atividades | Log de atividades |
| avaliacoes_performance | Avaliacoes de professores/staff |
| evolucao_alunos | Tracking de evolucao |
| relatorios_personalizados | Relatorios customizados |
| configuracoes_visibilidade | Visibilidade de dados |
| logs_sistema | Logs gerais |
| auditoria_dados | Auditoria completa de mudancas |
| configuracoes | Configuracoes gerais |

---

## ENUMs por Categoria

| Categoria | ENUMs | Qtd |
|-----------|-------|-----|
| Usuario e Acesso | user_role, genero, dominancia, posicao_preferida, nivel_jogo | 5 |
| Status Geral | status_geral | 1 |
| Quadras | tipo_esporte, tipo_piso, status_quadra, tipo_bloqueio, status_bloqueio, tipo_manutencao, status_manutencao | 7 |
| Agendamento | status_agendamento, tipo_agendamento, tipo_checkin, status_checkin | 4 |
| Aulas | status_aula, status_matricula, motivo_reposicao, status_reposicao | 4 |
| Financeiro | status_pagamento, forma_pagamento, tipo_plano, status_contrato, status_fatura, tipo_movimentacao, categoria_financeira | 7 |
| Torneios | status_torneio, categoria_torneio, tipo_disputa, status_inscricao, tipo_chave, fase_torneio, status_partida, criterio_sorteio, tipo_evento, status_evento | 10 |
| Comunicacao | tipo_notificacao, canal_envio, prioridade, status_notificacao, tipo_campanha, status_campanha, tipo_comunicacao, status_entrega, tipo_template | 9 |
| Config/Sistema | categoria_config, tipo_campo, ambiente, status_conexao, tipo_trigger, nivel_log, operacao_auditoria, origem_operacao | 8 |
| Modulos (v2.0) | tipo_relatorio, nivel_acesso_relatorio, status_modulo, tipo_modulo | 4 |
| **Plataforma (017)** | status_assinatura, tipo_evento_assinatura, tipo_webhook, status_webhook, tipo_anuncio, papel_arena | **6** |
| **Total** | | **65** |

---

## Decisoes Arquiteturais

### Base: Legacy v1.0 + v2.0 Melhorias + Platform Enhancements

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
| Multi-arena | **017 novo** | usuarios_arenas junction table para multi-propriedade |
| Ciclo de vida SaaS | **017 novo** | status_assinatura + eventos_assinatura para controle de trial/churn |
| Metricas plataforma | **017 novo** | MRR/ARR/churn tracking diario para o dono do SaaS |
| Webhooks | **017 novo** | Log e reconciliacao de webhooks do Asaas |

### Padrao de Extensao (Extension Tables)

Professores e funcionarios sao **tabelas de extensao** de usuarios:
- `professores` referencia `usuarios(id)` via `usuario_id`
- `funcionarios` referencia `usuarios(id)` via `usuario_id`
- Dados comuns ficam em `usuarios`, dados especificos nas tabelas de extensao

### Multi-Arena (Junction Table)

`usuarios_arenas` permite que um usuario gerencie multiplas arenas:
- Um `arena_admin` pode ser `proprietario` de varias arenas
- Campo `arena_ativa` indica qual arena esta selecionada no momento
- `usuarios.arena_id` permanece como arena "principal" (compatibilidade com RLS existente)

---

## Validacao Pos-Execucao

```sql
-- Verificar total de tabelas (esperado: 71)
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

-- Verificar ENUMs
SELECT typname FROM pg_type
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
AND typtype = 'e' ORDER BY typname;
```

---

**Proximos:** [Seguranca e RLS](./rls-and-security.md) | [Guia de Execucao](../../supabase/GUIA_EXECUCAO.md) | [Guia de Arquitetura](./ARCHITECTURE_GUIDE.md)
