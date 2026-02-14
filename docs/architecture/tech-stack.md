# Stack Tecnologica

[<- Voltar ao Indice](../README.md) | [Visao Geral](./system-overview.md)

---

## Resumo

| Camada | Tecnologia | Justificativa |
|--------|-----------|---------------|
| Frontend Web | Next.js 14 + TypeScript | SSR, App Router, ecossistema React |
| UI Components | Shadcn/UI + Tailwind CSS | Componentes acessiveis, customizaveis |
| Estado | Zustand + React Query | Leve, performatico, cache inteligente |
| Formularios | React Hook Form + Zod | Validacao type-safe, performance |
| Mobile | React Native + Expo | Cross-platform, compartilha logica com web |
| Backend | Supabase | PostgreSQL, Auth, Realtime, Storage, Edge Functions |
| Deploy Web | Vercel | Otimizado para Next.js, edge network |
| Deploy Mobile | EAS Build | Build nativo na cloud |

---

## Frontend Web - Detalhamento

### Next.js 14 (App Router)
- Server Components para performance
- Route Groups: `(auth)`, `(dashboard)`, `(super-admin)`
- API Routes para webhooks
- Middleware para autenticacao e redirecionamento

### Tailwind CSS + Shadcn/UI
- Design system consistente
- Componentes: Card, Button, Badge, Input, Select, Dialog, Tabs, Table
- Tema customizavel por arena (white-label)

### Zustand + React Query
- **Zustand**: Estado global (usuario logado, arena ativa, tema)
- **React Query**: Cache de dados remotos, invalidacao automatica, optimistic updates

### React Hook Form + Zod
- Formularios performaticos (sem re-renders desnecessarios)
- Validacao com schemas Zod compartilhados frontend/backend
- Mensagens de erro em portugues

### Graficos e Calendario
- **Recharts**: Graficos de receita, ocupacao, performance
- **Chart.js**: Graficos avancados quando necessario
- **FullCalendar.js**: Visualizacao de agenda semanal/mensal

---

## Mobile - Detalhamento

### React Native + Expo
- Expo Camera: Scan de QR Code para check-in
- Expo Notifications: Push notifications
- Expo Location: Check-in por geolocalizacao

### React Navigation v6
- Tab Navigator (bottom tabs)
- Stack Navigator (navegacao entre telas)
- Deep linking para notificacoes

---

## Backend - Detalhamento

### Supabase (PostgreSQL)
- **RLS**: Seguranca multi-tenant nativa
- **Realtime**: Subscriptions para atualizacoes em tempo real
- **Auth**: JWT tokens, magic links, OAuth
- **Storage**: Upload de fotos, logos, documentos
- **Edge Functions**: Logica server-side (Deno)

### Extensoes PostgreSQL
- `uuid-ossp`: Geracao de UUIDs
- `pgcrypto`: Criptografia
- `postgis`: Geolocalizacao (check-in por proximidade)

---

## Integracoes Externas

| Servico | Uso | Protocolo |
|---------|-----|-----------|
| **Evolution API** | WhatsApp (mensagens, templates) | REST + Webhook |
| **Asaas** | Pagamentos (PIX, boleto, cartao) | REST + Webhook |
| **n8n** | Automacoes (workflows) | Webhook triggers |
| **Resend** | Email transacional | REST |
| **Twilio** | SMS | REST |
| **Sentry** | Monitoramento de erros | SDK |
| **PostHog** | Analytics de produto | SDK |

---

## Variaveis de Ambiente

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Asaas
ASAAS_API_KEY=
ASAAS_ENVIRONMENT=sandbox

# WhatsApp (Evolution API)
EVOLUTION_API_URL=
EVOLUTION_API_KEY=
EVOLUTION_INSTANCE_NAME=

# Email
RESEND_API_KEY=

# Monitoramento
SENTRY_DSN=
NEXT_PUBLIC_POSTHOG_KEY=
```

---

**Proximos:** [Visao Geral](./system-overview.md) | [Schemas SQL](../database/schemas.md)
