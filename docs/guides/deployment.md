# Deploy

[<- Voltar ao Indice](../README.md) | [Sequencia de Implementacao](./implementation-sequence.md)

---

## Frontend Web - Vercel

### Setup

1. Conectar repositorio GitHub ao Vercel
2. Configurar variaveis de ambiente no Vercel Dashboard
3. Deploy automatico a cada push na branch `main`

### Variaveis de Ambiente (Vercel)

```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
ASAAS_API_KEY
ASAAS_ENVIRONMENT=production
ASAAS_WEBHOOK_TOKEN
EVOLUTION_API_URL
EVOLUTION_API_KEY
RESEND_API_KEY
ANTHROPIC_API_KEY
SENTRY_DSN
NEXT_PUBLIC_POSTHOG_KEY
```

### GitHub Actions

```yaml
name: Deploy Verana

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run test
      - run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
```

## Mobile - EAS Build

```bash
npm install -g eas-cli
eas login
eas build:configure
eas build --platform all
eas submit --platform ios
eas submit --platform android
```

## Database - Supabase

### Migrations
```bash
# Executar migrations (20 arquivos em ordem)
# Ver guia completo: supabase/GUIA_EXECUCAO.md
```

### Edge Functions

```bash
# Instalar Supabase CLI
npm install -g supabase

# Login
npx supabase login

# Link ao projeto
npx supabase link --project-ref <project-id>

# Deploy de Edge Functions (webhooks publicos com --no-verify-jwt)
npx supabase functions deploy asaas-webhook --no-verify-jwt
npx supabase functions deploy whatsapp-webhook --no-verify-jwt

# Deploy de Edge Functions (com JWT)
for fn in asaas-create-customer asaas-create-payment asaas-subscription \
          whatsapp-send email-send notification-dispatch \
          cron-billing cron-reminders cron-overdue cron-lifecycle \
          cron-process-queue cron-ai-insights cron-birthday \
          on-agendamento on-arena-created; do
  npx supabase functions deploy $fn
done

# Configurar secrets
npx supabase secrets set \
  ASAAS_API_KEY=xxx \
  ASAAS_WEBHOOK_TOKEN=xxx \
  EVOLUTION_API_URL=xxx \
  EVOLUTION_API_KEY=xxx \
  RESEND_API_KEY=xxx \
  ANTHROPIC_API_KEY=xxx
```

### Ativar Cron Jobs

Apos deploy das Edge Functions, ativar via SQL Editor. Detalhes em `docs/integrations/edge-functions.md`.

## Checklist de Deploy

- [ ] Variaveis de ambiente configuradas (Vercel + Supabase secrets)
- [ ] Migrations SQL executadas (20 arquivos em ordem)
- [ ] Edge Functions deployadas (14+ funcoes)
- [ ] Cron jobs ativados via SQL
- [ ] RLS testado em producao
- [ ] Asaas em modo `production` com webhook URL configurado
- [ ] WhatsApp (Evolution API) com webhook URL configurado
- [ ] Sentry configurado para monitoramento
- [ ] Dominio customizado configurado
- [ ] SSL ativo

---

**Proximos:** [Getting Started](./getting-started.md) | [Sequencia de Implementacao](./implementation-sequence.md)
