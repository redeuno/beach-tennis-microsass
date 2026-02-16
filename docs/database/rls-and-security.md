# Seguranca, RLS, Triggers e Indices

[<- Voltar ao Indice](../README.md) | [Schemas SQL](./schemas.md)

---

## Row Level Security (RLS)

### Implementacao

Os arquivos `supabase/migrations/012_rls_policies.sql`, `018_platform_rls_triggers_indexes.sql` e `020_edge_functions_rls_triggers_indexes.sql` contem a implementacao completa de RLS com:

- **RLS habilitado em TODAS as 76 tabelas**
- **Helper functions** para evitar subqueries repetidas:
  - `auth_user_arena_id()` - retorna arena_id do usuario autenticado
  - `auth_user_role()` - retorna tipo_usuario do usuario autenticado
  - `auth_user_id()` - retorna id do usuario autenticado
  - `is_super_admin()` - verifica se e super admin
  - `auth_user_arena_ids()` - **NOVO** - retorna todos os arena_ids do usuario (multi-arena)
  - `is_arena_proprietario(arena_id)` - **NOVO** - verifica se e proprietario de uma arena especifica
- **Politicas granulares por role** (nao apenas tenant isolation)
- **~120 policies** cobrindo todos os cenarios de acesso

### Hierarquia de Acesso

```
super_admin    -> Acesso total a TODAS as arenas e dados da plataforma
arena_admin    -> Gerencia completa da(s) propria(s) arena(s) — pode ter multiplas
funcionario    -> Operacoes do dia-a-dia (agendamentos, checkins, quadras)
professor      -> Gerencia de aulas e evolucao de alunos
aluno          -> Visualizacao propria + agendamentos + inscricoes
```

### Multi-Arena: Como Funciona

Com a tabela `usuarios_arenas`, um usuario pode estar vinculado a multiplas arenas:

1. **Proprietarios** podem ter `is_proprietario = true` em varias arenas
2. **arena_ativa = true** indica qual arena esta no contexto atual (switch de conta)
3. As helper functions RLS usam `auth_user_arena_id()` que retorna a arena principal do `usuarios.arena_id`
4. A funcao `auth_user_arena_ids()` retorna TODAS as arenas do usuario

### Matriz de Permissoes por Tabela

| Tabela | super_admin | arena_admin | funcionario | professor | aluno |
|--------|:-----------:|:-----------:|:-----------:|:---------:|:-----:|
| arenas | ALL | SELECT | SELECT | SELECT | SELECT |
| usuarios | ALL | ALL | SELECT | SELECT | SELECT (propria arena) |
| quadras | ALL | ALL | ALL | SELECT | SELECT |
| agendamentos | ALL | ALL | ALL | SELECT | SELECT + INSERT/UPDATE proprios |
| aulas | ALL | ALL | ALL | ALL (proprias) | SELECT |
| faturas | ALL | ALL | ALL | - | SELECT (proprias) |
| contratos | ALL | ALL | ALL | - | SELECT (proprios) |
| torneios | ALL | ALL | ALL | SELECT | SELECT |
| notificacoes | ALL | ALL | - | - | SELECT + UPDATE (proprias) |
| integracoes* | ALL | ALL | - | - | - |
| config/audit | ALL | ALL | - | - | - |
| **usuarios_arenas** | ALL | ALL (arena) | - | - | SELECT (proprios) |
| **eventos_assinatura** | ALL | SELECT (arena) | - | - | - |
| **webhook_events** | ALL | SELECT (arena) | - | - | - |
| **uso_plataforma** | ALL | SELECT (arena) | - | - | - |
| **anuncios_plataforma** | ALL | SELECT (ativos) | SELECT (ativos) | SELECT (ativos) | SELECT (ativos) |
| **anuncios_lidos** | ALL | ALL (proprios) | ALL (proprios) | ALL (proprios) | ALL (proprios) |
| **metricas_plataforma** | ALL | - | - | - | - |

*integracoes = integracao_whatsapp, integracao_asaas, automacoes

### Automacao e AI (019/020) — Novas Tabelas

| Tabela | super_admin | arena_admin | funcionario | professor | aluno |
|--------|:-----------:|:-----------:|:-----------:|:---------:|:-----:|
| **fila_mensagens** | ALL | ALL (arena) | SELECT (arena) | - | - |
| **chatbot_conversas** | ALL | ALL (arena) | SELECT (arena) | - | - |
| **chatbot_mensagens** | ALL | ALL (arena) | SELECT (arena) | - | - |
| **insights_arena** | ALL | ALL (arena) | - | - | - |
| **cron_jobs_config** | ALL | SELECT | - | - | - |

### Principios de Seguranca

1. **Tenant Isolation**: Usuarios so acessam dados da propria arena via `arena_id`
2. **Least Privilege**: Cada role tem acesso minimo necessario
3. **SECURITY DEFINER**: Helper functions rodam com privilegios elevados para evitar recursao nas policies
4. **Separacao SELECT vs ALL**: Policies de leitura separadas de policies de escrita para maior granularidade
5. **Multi-arena seguro**: Mesmo com vinculos multiplos, RLS garante isolamento por arena ativa

---

## Triggers e Funcoes

### update_updated_at_column()
- **Tipo**: BEFORE UPDATE
- **Aplicado em**: Todas as tabelas com campo `updated_at` (~50 tabelas)
- **Funcao**: Atualiza automaticamente `updated_at` a cada UPDATE

### audit_trigger_function()
- **Tipo**: AFTER INSERT/UPDATE/DELETE (SECURITY DEFINER)
- **Aplicado em**: usuarios, agendamentos, faturas, quadras, aulas, contratos, torneios, eventos_assinatura, webhook_events, chatbot_conversas
- **Funcao**: Registra todas as mudancas na tabela `auditoria_dados`
- **Dados registrados**: tabela, operacao, dados anteriores, dados novos, usuario responsavel, origem

### generate_invoice_number()
- **Tipo**: BEFORE INSERT
- **Aplicado em**: faturas
- **Funcao**: Gera automaticamente `numero_fatura` sequencial por arena (formato: 000001)

### apply_default_configurations()
- **Tipo**: AFTER INSERT
- **Aplicado em**: arenas
- **Funcao**: Copia configuracoes padrao (template UUID zero) para cada nova arena criada

---

## Indices

Os arquivos `014_indexes.sql`, `018_platform_rls_triggers_indexes.sql` e `020_edge_functions_rls_triggers_indexes.sql` criam indices otimizados para:

- **Tenant isolation**: `arena_id` em todas as tabelas principais
- **Consultas de agendamento**: Compostos por arena + data + status
- **Financeiro**: Faturas por vencimento, status, asaas_payment_id
- **Auditoria**: Logs por arena + timestamp
- **Performance**: Indices compostos para queries complexas do dashboard
- **Multi-arena**: Indices parciais em usuarios_arenas (arena_ativa, is_proprietario)
- **Plataforma**: Indices em status_assinatura, trial, subdomain, webhooks
- **Fila de mensagens**: Indice parcial em status=pendente para processamento rapido
- **Chatbot**: Indices em conversas ativas e escaladas para humano
- **Insights**: Indice em insights nao lidos por arena

---

## Views para Relatorios

| View | Descricao |
|------|-----------|
| `vw_ocupacao_quadras` | Taxa de ocupacao por quadra e dia |
| `vw_receita_mensal` | Receita total, recebida e vencida por mes |
| `vw_performance_professores` | Metricas de cada professor (aulas, avaliacao, receita) |
| `vw_estatisticas_alunos` | Presenca e gastos de cada aluno |
| `vw_dashboard_resumo` | Visao geral da arena para o dashboard |

---

**Proximos:** [Schemas SQL](./schemas.md) | [Guia de Execucao](../../supabase/GUIA_EXECUCAO.md) | [Guia de Arquitetura](./ARCHITECTURE_GUIDE.md)
