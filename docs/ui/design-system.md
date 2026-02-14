# Design System

[<- Voltar ao Indice](../README.md) | [Wireframes](./wireframes.md)

---

## Layout Geral (Desktop)

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER: Logo | Arena Atual | Notificacoes | Perfil              │
├─────────────────────────────────────────────────────────────────┤
│ SIDEBAR:        │ MAIN CONTENT AREA                             │
│ ├ Dashboard     │                                               │
│ ├ Agendamentos  │ ┌─ Breadcrumb ─────────────────────────────┐ │
│ ├ Quadras       │ │ Home > Agendamentos > Hoje               │ │
│ ├ Pessoas       │ └─────────────────────────────────────────────┘ │
│ ├ Aulas         │                                               │
│ ├ Financeiro    │ ┌─ PAGE TITLE & ACTIONS ──────────────────┐ │
│ ├ Torneios      │ │ Agendamentos          [+ Novo] [Filtro] │ │
│ ├ Relatorios    │ └─────────────────────────────────────────────┘ │
│ └ Configuracoes │                                               │
│                 │ ┌─ CONTENT ─────────────────────────────────┐ │
│                 │ │     Conteudo principal da pagina          │ │
│                 │ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Cores Padrao

| Token | Cor | Uso |
|-------|-----|-----|
| `primary` | #0066CC | Acoes principais, links, destaques |
| `secondary` | #FF6B35 | Acentos, CTAs secundarios |
| `success` | verde (green-600) | Confirmado, ativo, pago |
| `warning` | amarelo (yellow-600) | Pendente, atencao |
| `danger` | vermelho (red-600) | Cancelado, vencido, erro |
| `info` | laranja (orange-600) | Manutencao, alerta |

> Cores customizaveis por arena via `arenas.cores_tema` (white-label).

## Status Indicators

| Indicador | Cor | Contexto |
|-----------|-----|----------|
| Confirmado/Ativo/Pago | `bg-green-100 text-green-800` | Agendamentos, usuarios, faturas |
| Pendente/Aguardando | `bg-yellow-100 text-yellow-800` | Agendamentos, pagamentos |
| Cancelado/Inativo/Vencido | `bg-red-100 text-red-800` | Cancelamentos, inadimplencia |
| Atencao/Manutencao | `bg-orange-100 text-orange-800` | Bloqueios, alertas |

## Componentes Base (Shadcn/UI)

### MetricCard

```typescript
interface MetricCardProps {
  title: string
  value: string | number
  change?: number
  trend?: 'up' | 'down' | 'stable'
  icon?: React.ReactNode
}
```

Uso: Cards de metricas no dashboard e paginas de resumo.

### StatusBadge

```typescript
interface StatusBadgeProps {
  status: 'confirmado' | 'pendente' | 'cancelado' | 'manutencao'
}
```

Uso: Indicadores de status em listas e cards.

### Componentes Utilizados

| Componente | Uso |
|------------|-----|
| Card | Containers de conteudo, metricas |
| Button | Acoes (primary, outline, destructive) |
| Badge | Status, tags, labels |
| Input | Campos de formulario |
| Select | Dropdowns, filtros |
| Dialog | Modais de formulario e confirmacao |
| Tabs | Navegacao em abas |
| Table | Listagens de dados |
| Avatar | Fotos de usuario |
| Calendar | Seletor de data |
| Toast | Notificacoes de sucesso/erro |

## Icones

Biblioteca: **Lucide React**

| Contexto | Icones |
|----------|--------|
| Navegacao | Users, Calendar, DollarSign, Trophy, Settings |
| Acoes | Plus, Search, Filter, Edit, Trash |
| Status | Check, Clock, AlertCircle, X |
| Esporte | GraduationCap (professor), Briefcase (staff) |

## Responsividade

| Breakpoint | Layout |
|------------|--------|
| Desktop (lg+) | Sidebar fixa + conteudo principal |
| Tablet (md) | Sidebar colapsavel + grid 2 colunas |
| Mobile (sm) | Sem sidebar + grid 1 coluna + bottom nav |
