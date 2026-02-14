# Deploy

[<- Voltar ao Indice](../README.md) | [Sequencia de Implementacao](./implementation-sequence.md)

---

## Frontend Web - Vercel

### Setup

1. Conectar repositorio GitHub ao Vercel
2. Configurar variaveis de ambiente no Vercel Dashboard
3. Deploy automatico a cada push na branch `main`

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
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
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

### Variaveis de Ambiente (Vercel)

```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
ASAAS_API_KEY
ASAAS_ENVIRONMENT=production
EVOLUTION_API_URL
EVOLUTION_API_KEY
EVOLUTION_INSTANCE_NAME
RESEND_API_KEY
SENTRY_DSN
NEXT_PUBLIC_POSTHOG_KEY
```

## Mobile - EAS Build

### Setup

```bash
npm install -g eas-cli
eas login
eas build:configure
```

### Build

```bash
# iOS
eas build --platform ios

# Android
eas build --platform android

# Ambos
eas build --platform all
```

### Submit

```bash
eas submit --platform ios
eas submit --platform android
```

## Database - Supabase

### Migrations

Usar Supabase CLI para gerenciar migrations:

```bash
npx supabase init
npx supabase db diff --file migration_name
npx supabase db push
```

### Edge Functions

```bash
npx supabase functions deploy function-name
```

## Checklist de Deploy

- [ ] Variaveis de ambiente configuradas
- [ ] RLS testado em producao
- [ ] Asaas em modo `production`
- [ ] WhatsApp (Evolution API) configurado
- [ ] Sentry configurado para monitoramento
- [ ] Dominio customizado configurado
- [ ] SSL ativo
- [ ] Backup automatico do banco configurado

---

**Proximos:** [Getting Started](./getting-started.md) | [Sequencia de Implementacao](./implementation-sequence.md)
