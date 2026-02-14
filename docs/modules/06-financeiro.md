# Modulo 6: Gestao Financeira

[<- Voltar aos Modulos](./README.md)

**Plano minimo:** Basico (parcial) | Pro (completo)

---

## Descricao

Controle financeiro completo com contratos, faturas, cobrancas automaticas via Asaas e comissoes de professores.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Contratos | Mensalidades, planos, beneficios inclusos |
| Faturas | Emissao, vencimento, pagamento |
| Cobranca Automatica | Integracao Asaas (PIX, boleto, cartao) |
| Movimentacoes | Receitas, despesas, transferencias |
| Comissoes | Calculo de comissoes de professores |
| Inadimplencia | Alertas e fluxo de cobranca |
| Dashboard Financeiro | Resumo mensal, graficos, KPIs |

## Tabelas Relacionadas

- `contratos` - Contratos de alunos
- `faturas` - Faturas emitidas
- `movimentacoes_financeiras` - Fluxo de caixa

## Integracao Asaas

Veja detalhes em [Integracao Asaas](../integrations/asaas.md).

## KPIs

- Receita mensal
- Despesas mensais
- Lucro (margem)
- Taxa de inadimplencia
- Faturas vencendo/vencidas

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Leitura + cobrar |
| professor | Visualizar proprias comissoes |
| aluno | Visualizar proprias faturas |

## Rota

```
app/(dashboard)/financeiro/
```
