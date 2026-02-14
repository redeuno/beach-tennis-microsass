# Sequencia de Implementacao

[<- Voltar ao Indice](../README.md) | [Getting Started](./getting-started.md) | [Deploy](./deployment.md)

---

## Estrategia

1. **Database First**: Schemas antes do frontend
2. **Modular**: Um modulo por vez
3. **Incremental**: Cada etapa adiciona funcionalidades
4. **Testavel**: Validar cada etapa antes de prosseguir

## Sequencia dos Prompts

A implementacao segue 11 prompts sequenciais. Os prompts completos estao nos documentos legados:
- Prompts 0-7: [`11-beach-tennis-microsass/current/verana-prompts-lovable-completo.md`](../../11-beach-tennis-microsass/current/verana-prompts-lovable-completo.md)
- Prompts 8-10: [`11-beach-tennis-microsass/current/prompts-8-10.md`](../../11-beach-tennis-microsass/current/prompts-8-10.md)

### Fase 1: Fundacao

| # | Prompt | Escopo | Dependencias |
|---|--------|--------|--------------|
| 0 | Setup + Database | Extensoes, ENUMs, config inicial | Nenhuma |
| 1 | Tabelas Principais | Arenas, usuarios, quadras | Prompt 0 |
| 2 | Frontend + Auth | Estrutura Next.js, Supabase Auth, layout | Prompt 1 |
| 3 | Permissoes + RLS | Sistema de roles, politicas RLS | Prompt 2 |

### Fase 2: Core Business

| # | Prompt | Escopo | Dependencias |
|---|--------|--------|--------------|
| 4 | Gestao de Quadras | CRUD quadras, bloqueios, manutencoes | Prompt 3 |
| 5 | Agendamentos | Reservas, calendario, lista espera | Prompt 4 |
| 6 | Gestao de Usuarios | Perfis, professores, funcionarios | Prompt 3 |
| 7 | Financeiro + Asaas | Contratos, faturas, cobrancas | Prompt 6 |

### Fase 3: Features Avancadas

| # | Prompt | Escopo | Dependencias |
|---|--------|--------|--------------|
| 8 | Aulas + Check-in | Aulas, presenca, QR Code, GPS | Prompt 5 + 6 |
| 9 | Torneios + Eventos | Inscricoes, chaveamento, ranking | Prompt 6 |
| 10 | Comunicacao + WhatsApp | Templates, campanhas, webhooks | Prompt 7 |

## Checklist por Prompt

Para cada prompt, verificar:

- [ ] Tabelas criadas no Supabase
- [ ] RLS ativo e testado
- [ ] Componentes frontend funcionando
- [ ] Formularios com validacao Zod
- [ ] CRUD completo (Create, Read, Update, Delete)
- [ ] Responsividade verificada
- [ ] Permissoes por role testadas

## Ordem de Execucao

```
Prompt 0 -> 1 -> 2 -> 3 -> 4 -> 5
                              └-> 6 -> 7 -> 8
                                        └-> 9
                                        └-> 10
```

---

**Proximos:** [Getting Started](./getting-started.md) | [Deploy](./deployment.md)
