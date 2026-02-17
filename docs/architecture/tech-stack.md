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
| Automacoes | Supabase Edge Functions + pg_cron | Sem dependencia externa (zero n8n) |
| AI | Claude API (Anthropic) | Chatbot WhatsApp, insights, campanhas |
| Deploy Web | Vercel | Otimizado para Next.js, edge network |
| Deploy Mobile | EAS Build | Build nativo na cloud |

---

## Frontend Web - Detalhamento

### Next.js 14 (App Router)
- Server Components para performance
- Route Groups: `(auth)`, `(dashboard)`, `(super-admin)`
- API Routes para webhooks (fallback — Edge Functions sao preferidas)
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
- **RLS**: Seguranca multi-tenant nativa (76 tabelas, ~130 policies)
- **Realtime**: Subscriptions para atualizacoes em tempo real
- **Auth**: JWT tokens, magic links, OAuth
- **Storage**: Upload de fotos, logos, documentos
- **Edge Functions**: 14+ funcoes Deno para logica server-side
- **pg_cron**: Agendamento de automacoes (substitui n8n)
- **pg_net**: Chamadas HTTP de dentro do banco

### Extensoes PostgreSQL
- `uuid-ossp`: Geracao de UUIDs
- `pgcrypto`: Criptografia
- `postgis`: Geolocalizacao (check-in por proximidade)
- `pg_cron`: Agendamento de tarefas periodicas
- `pg_net`: Requisicoes HTTP assincronas

---

## Integracoes Externas

| Servico | Uso | Protocolo | Edge Function |
|---------|-----|-----------|--------------|
| **Asaas** | Pagamentos (PIX, boleto, cartao) | REST + Webhook | `asaas-*` |
| **Evolution API** | WhatsApp (mensagens, templates, chatbot AI) | REST + Webhook | `whatsapp-*` |
| **Resend** | Email transacional | REST | `email-send` |
| **Claude API** | AI (chatbot, insights, campanhas) | REST | `whatsapp-webhook`, `cron-ai-insights` |
| **Sentry** | Monitoramento de erros | SDK | Frontend |
| **PostHog** | Analytics de produto | SDK | Frontend |

---

## Variaveis de Ambiente

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Asaas (pagamentos)
ASAAS_API_KEY=
ASAAS_ENVIRONMENT=sandbox
ASAAS_WEBHOOK_TOKEN=

# WhatsApp (Evolution API)
EVOLUTION_API_URL=
EVOLUTION_API_KEY=

# Email
RESEND_API_KEY=

# AI (Claude)
ANTHROPIC_API_KEY=

# Monitoramento
SENTRY_DSN=
NEXT_PUBLIC_POSTHOG_KEY=
```

---

**Proximos:** [Visao Geral](./system-overview.md) | [Schemas SQL](../database/schemas.md) | [Edge Functions](../integrations/edge-functions.md)
