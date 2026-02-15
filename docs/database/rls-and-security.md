# Seguranca, RLS, Triggers e Indices

[<- Voltar ao Indice](../README.md) | [Schemas SQL](./schemas.md)

---

## Row Level Security (RLS)

### Implementacao

O arquivo `supabase/migrations/012_rls_policies.sql` contem a implementacao completa de RLS com:

- **RLS habilitado em TODAS as tabelas** (~60 tabelas)
- **Helper functions** para evitar subqueries repetidas:
  - `auth_user_arena_id()` - retorna arena_id do usuario autenticado
  - `auth_user_role()` - retorna tipo_usuario do usuario autenticado
  - `auth_user_id()` - retorna id do usuario autenticado
  - `is_super_admin()` - verifica se e super admin
- **Politicas granulares por role** (nao apenas tenant isolation)

### Hierarquia de Acesso

```
super_admin    -> Acesso total a TODAS as arenas e dados
arena_admin    -> Gerencia completa da propria arena
funcionario    -> Operacoes do dia-a-dia (agendamentos, checkins, quadras)
professor      -> Gerencia de aulas e evolucao de alunos
aluno          -> Visualizacao propria + agendamentos + inscricoes
```

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

*integracoes = integracao_whatsapp, integracao_asaas, automacoes_n8n

### Principios de Seguranca

1. **Tenant Isolation**: Usuarios so acessam dados da propria arena via `arena_id`
2. **Least Privilege**: Cada role tem acesso minimo necessario
3. **SECURITY DEFINER**: Helper functions rodam com privilegios elevados para evitar recursao nas policies
4. **Separacao SELECT vs ALL**: Policies de leitura separadas de policies de escrita para maior granularidade

---

## Triggers e Funcoes

### update_updated_at_column()
- **Tipo**: BEFORE UPDATE
- **Aplicado em**: Todas as tabelas com campo `updated_at`
- **Funcao**: Atualiza automaticamente `updated_at` a cada UPDATE

### audit_trigger_function()
- **Tipo**: AFTER INSERT/UPDATE/DELETE (SECURITY DEFINER)
- **Aplicado em**: usuarios, agendamentos, faturas, quadras, aulas, contratos, torneios
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

O arquivo `014_indexes.sql` cria indices otimizados para:

- **Tenant isolation**: `arena_id` em todas as tabelas principais
- **Consultas de agendamento**: Compostos por arena + data + status
- **Financeiro**: Faturas por vencimento, status, asaas_payment_id
- **Auditoria**: Logs por arena + timestamp
- **Performance**: Indices compostos para queries complexas do dashboard

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

**Proximos:** [Schemas SQL](./schemas.md) | [Guia de Execucao](../../supabase/GUIA_EXECUCAO.md)
