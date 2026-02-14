# Wireframes

[<- Voltar ao Indice](../README.md) | [Design System](./design-system.md)

---

## Dashboard Principal (Admin Arena)

```
┌─ DASHBOARD VERANA BEACH TENNIS ──────────────────────────────────────┐
│ ┌─ METRICAS HOJE ─────────────────────────────────────────────────┐  │
│ │ ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────────┐ │  │
│ │ │Agendamen. │ │ Check-ins │ │  Receita  │ │    Ocupacao       │ │  │
│ │ │    24     │ │    18     │ │ R$ 1.250  │ │ ████████░░ 80%    │ │  │
│ │ │   + 12%   │ │   - 5%   │ │  + 15%    │ │ Quadra 1: 90%     │ │  │
│ │ └───────────┘ └───────────┘ └───────────┘ │ Quadra 2: 70%     │ │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AGENDA HOJE ──────────────────┐ ┌─ ALERTAS E NOTIFICACOES ─────┐  │
│ │ 08:00 - Quadra 1              │ │ ! 3 pagamentos vencidos       │  │
│ │ Joao Silva (Beach Tennis)      │ │ * Aula cancelada - Quadra 2   │  │
│ │ [Check-in: OK]                │ │ $ Nova mensalidade recebida    │  │
│ │ 09:00 - Quadra 2              │ │ # Torneio em 3 dias           │  │
│ │ Maria Santos (Aula Grupo)      │ │ [Ver todas as notificacoes]   │  │
│ │ [Check-in: Pendente]          │ └───────────────────────────────┘  │
│ │ [Ver agenda completa]          │                                   │
│ └───────────────────────────────┘                                   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Agendamentos - Interface Principal

```
┌─ AGENDAMENTOS ───────────────────────────────────────────────────────┐
│ ┌─ FILTROS ──────────────────────────────────────────────────────┐   │
│ │ [Hoje v] [Todas Quadras v] [Todos Status v] [Buscar...]       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                    [+ Novo Agendamento] │
│                                                                      │
│ ┌─ AGENDAMENTOS HOJE ─────────────────────────────────────────────┐  │
│ │ ┌──────────────────────────────────────────────────────────────┐ │  │
│ │ │ 08:00 - 09:00 | Quadra 1 | Joao Silva                       │ │  │
│ │ │ Beach Tennis Individual  | R$ 60,00 | [OK] CONFIRMADO        │ │  │
│ │ │ Check-in: OK 07:58 | Participantes: 2                       │ │  │
│ │ │ [Ver] [Editar] [Cancelar] [WhatsApp]                        │ │  │
│ │ └──────────────────────────────────────────────────────────────┘ │  │
│ └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Check-in Mobile

```
┌─ CHECK-IN ─────────────────────────────────────────────────────┐
│ ┌─ AGENDAMENTO ─────────────────────────────────────────────┐  │
│ │ Joao Silva - Beach Tennis - Quadra 1                     │  │
│ │ 27/09/2025 - 08:00 as 09:00                             │  │
│ └──────────────────────────────────────────────────────────┘  │
│                                                                │
│ ┌─ METODOS DE CHECK-IN ─────────────────────────────────────┐  │
│ │ ┌─────────────────────────────────────────────────────┐   │  │
│ │ │              QR CODE                                │   │  │
│ │ │      [Escanear com camera]                          │   │  │
│ │ └─────────────────────────────────────────────────────┘   │  │
│ │                                                           │  │
│ │ ┌─────────────────────────────────────────────────────┐   │  │
│ │ │              LOCALIZACAO                            │   │  │
│ │ │ Voce esta proximo a arena - 15 metros               │   │  │
│ │ │      [Check-in por Localizacao]                     │   │  │
│ │ └─────────────────────────────────────────────────────┘   │  │
│ └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

---

## Gestao Financeira

```
┌─ FINANCEIRO ─────────────────────────────────────────────────────────┐
│ ┌─ RESUMO MENSAL ────────────────────────────────────────────────┐   │
│ │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────┐ │   │
│ │ │   RECEITA    │ │   DESPESAS   │ │     LUCRO    │ │INADIMP.│ │   │
│ │ │  R$ 28.450   │ │  R$ 12.800   │ │  R$ 15.650   │ │  3.2%  │ │   │
│ │ │    + 15%     │ │    + 8%      │ │    + 22%     │ │ - 1.1% │ │   │
│ │ └──────────────┘ └──────────────┘ └──────────────┘ └────────┘ │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ PROXIMOS VENCIMENTOS ────┐ ┌─ MOVIMENTACOES RECENTES ──────────┐  │
│ │ HOJE (5)                  │ │ OK Joao Silva - R$ 120 (PIX)      │  │
│ │ * Joao Silva - R$ 120    │ │ OK Maria Costa - R$ 80 (Cartao)   │  │
│ │ * Maria Costa - R$ 150   │ │ X  Pedro Santos - R$ 150          │  │
│ │ [Cobrar Todos]            │ │    Falha no cartao                │  │
│ │                           │ │ [Ver Todas]                       │  │
│ │ VENCIDOS (3)              │ └───────────────────────────────────┘  │
│ │ * Ana Silva - R$ 120     │                                        │
│ │   (3 dias em atraso)     │                                        │
│ │ [Acionar Cobranca]       │                                        │
│ └───────────────────────────┘                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Fluxos de Usuario (UX)

### Fluxo de Agendamento (Cliente)
```
Login -> Selecionar data/hora -> Escolher quadra -> Confirmar -> Pagar -> Confirmacao (WhatsApp + Email)
```

### Fluxo de Check-in (Mobile)
```
Abrir app -> Selecionar agendamento -> Escolher metodo (QR/GPS/Manual) -> Confirmar -> Liberado
```

### Fluxo de Cobranca (Admin)
```
Dashboard financeiro -> Selecionar clientes -> Gerar cobrancas (Asaas) -> Notificar (WhatsApp) -> Acompanhar
```

---

**Proximos:** [Design System](./design-system.md) | [Modulos](../modules/)
