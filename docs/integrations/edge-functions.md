# Edge Functions — Especificacao Tecnica

[<- Voltar ao Indice](../README.md) | [Automacoes](./automations.md)

---

## Visao Geral

14+ Edge Functions (Deno/TypeScript) deployadas no Supabase para toda logica server-side.

**Runtime:** Deno (Supabase Edge Functions)
**Deploy:** `npx supabase functions deploy <nome>`
**Timeout:** 60s (Free) / 150s (Pro)

## Estrutura de Pastas

```
supabase/
├── functions/
│   ├── _shared/                    # Codigo compartilhado
│   │   ├── supabase-client.ts      # Supabase admin client
│   │   ├── asaas-client.ts         # Asaas API wrapper
│   │   ├── whatsapp-client.ts      # Evolution API wrapper
│   │   ├── email-client.ts         # Resend wrapper
│   │   ├── ai-client.ts            # Claude API wrapper
│   │   ├── cors.ts                 # CORS headers
│   │   └── types.ts                # Tipos compartilhados
│   │
│   ├── asaas-webhook/index.ts
│   ├── asaas-create-customer/index.ts
│   ├── asaas-create-payment/index.ts
│   ├── asaas-subscription/index.ts
│   ├── whatsapp-send/index.ts
│   ├── whatsapp-webhook/index.ts
│   ├── email-send/index.ts
│   ├── notification-dispatch/index.ts
│   ├── cron-billing/index.ts
│   ├── cron-reminders/index.ts
│   ├── cron-overdue/index.ts
│   ├── cron-lifecycle/index.ts
│   ├── cron-process-queue/index.ts
│   ├── cron-ai-insights/index.ts
│   ├── cron-birthday/index.ts
│   ├── on-agendamento/index.ts
│   └── on-arena-created/index.ts
│
└── migrations/                     # 20 SQL migrations
```

## Especificacao por Edge Function

### asaas-webhook (//HIGH-RISK)
- **Endpoint:** POST /functions/v1/asaas-webhook (public, --no-verify-jwt)
- **Input:** Asaas webhook payload (event + payment data)
- **Fluxo:** Valida token → registra webhook_events → busca fatura → atualiza status → notifica
- **Output:** `{ received: true }`

### asaas-create-payment (//HIGH-RISK)
- **Endpoint:** POST /functions/v1/asaas-create-payment
- **Input:** `{ fatura_id: UUID }`
- **Fluxo:** Busca fatura + cliente + credenciais → chama API Asaas → salva payment_id + QR code
- **Output:** `{ payment_id, invoice_url, qr_code }`

### whatsapp-webhook
- **Endpoint:** POST /functions/v1/whatsapp-webhook (public, --no-verify-jwt)
- **Input:** Evolution API webhook payload
- **Fluxo:** Identifica arena → busca conversa → AI processa intent → responde ou escala
- **Output:** `{ processed: true }`

### cron-process-queue
- **Trigger:** pg_cron a cada 1 minuto
- **Fluxo:** SELECT pendentes (limit 30) → processa por canal → atualiza status → registra historico
- **Rate limits:** WhatsApp 30/min, Email 100/min

### cron-lifecycle (//HIGH-RISK)
- **Trigger:** pg_cron diario 00:30
- **Fluxo:** Expira trials → marca inadimplentes → suspende → gera metricas_plataforma

## Variaveis de Ambiente (Secrets)

```bash
# Configurar via CLI
npx supabase secrets set \
  ASAAS_API_KEY=xxx \
  ASAAS_WEBHOOK_TOKEN=xxx \
  EVOLUTION_API_URL=xxx \
  EVOLUTION_API_KEY=xxx \
  RESEND_API_KEY=xxx \
  ANTHROPIC_API_KEY=xxx \
  WEBHOOK_SECRET=xxx
```

## Deploy

```bash
# Deploy individual
npx supabase functions deploy asaas-webhook --no-verify-jwt

# Deploy todas
for fn in asaas-webhook asaas-create-customer asaas-create-payment \
          whatsapp-send whatsapp-webhook email-send notification-dispatch \
          cron-billing cron-reminders cron-overdue cron-lifecycle \
          cron-process-queue cron-ai-insights cron-birthday \
          on-agendamento on-arena-created; do
  npx supabase functions deploy $fn
done

# Webhooks publicos (sem JWT)
npx supabase functions deploy asaas-webhook --no-verify-jwt
npx supabase functions deploy whatsapp-webhook --no-verify-jwt
```

---

**Proximos:** [Automacoes](./automations.md) | [AI Integration](./ai-integration.md)
