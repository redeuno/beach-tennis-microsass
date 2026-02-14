# Modulos Funcionais

[<- Voltar ao Indice](../README.md)

---

## Visao Geral

O sistema e composto por 8 modulos funcionais, ativados conforme o plano contratado pela arena.

| # | Modulo | Tipo | Plano Minimo |
|---|--------|------|--------------|
| 0 | [Super Admin](./00-super-admin.md) | core | Plataforma |
| 1 | [Arenas](./01-arenas.md) | core | Basico |
| 2 | [Quadras](./02-quadras.md) | core | Basico |
| 3 | [Pessoas](./03-pessoas.md) | core | Basico |
| 4 | [Agendamentos](./04-agendamentos.md) | core | Basico |
| 5 | [Aulas](./05-aulas.md) | premium | Pro |
| 6 | [Financeiro](./06-financeiro.md) | financeiro | Basico (parcial) / Pro (completo) |
| 7 | [Torneios e Eventos](./07-torneios-eventos.md) | premium | Premium |

## Dependencias entre Modulos

```
Super Admin (M0)
  └── Arenas (M1)
        ├── Quadras (M2)
        │     └── Agendamentos (M4) ── Aulas (M5)
        ├── Pessoas (M3) ──────────────┘    │
        ├── Financeiro (M6) ◄───────────────┘
        └── Torneios (M7) ◄── Quadras (M2) + Pessoas (M3)
```

## Codigos de Modulo (para `modulos_sistema`)

| Codigo | Nome |
|--------|------|
| `dashboard` | Dashboard |
| `arenas` | Gestao de Arenas |
| `quadras` | Gestao de Quadras |
| `pessoas` | Gestao de Pessoas |
| `agendamentos` | Agendamentos |
| `aulas` | Gestao de Aulas |
| `financeiro` | Gestao Financeira |
| `torneios` | Torneios e Eventos |
| `relatorios` | Relatorios |
| `comunicacao` | Comunicacao |
| `integracoes` | Integracoes |
