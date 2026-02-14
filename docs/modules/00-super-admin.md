# Modulo 0: Super Admin

[<- Voltar aos Modulos](./README.md)

---

## Descricao

Painel de controle da plataforma white-label. Gerencia todas as arenas, planos, modulos e faturamento da plataforma.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Gestao de Planos | Criar/editar planos do sistema (Basico, Pro, Premium) |
| Controle de Arenas | Ativar/desativar arenas, gerenciar assinaturas |
| Gestao de Modulos | Ativar/desativar modulos por arena |
| Faturamento Consolidado | Receita total da plataforma, cobrancas |
| Relatorios Multi-tenant | Metricas consolidadas de todas as arenas |

## Tabelas Relacionadas

- `planos_sistema` - Planos disponiveis
- `modulos_sistema` - Modulos do sistema
- `arenas_planos` - Planos ativos por arena
- `arena_modulos` - Modulos ativos por arena

## Permissoes

Somente `super_admin` tem acesso a este modulo.

## KPIs

- ARR (Annual Recurring Revenue)
- Churn rate de arenas
- Uso por modulo
- Crescimento de usuarios

## Rota

```
app/(super-admin)/
```
