# Integracao Asaas - Pagamentos

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Basico (parcial) | Pro (completo)

---

## Visao Geral

Plataforma de pagamentos para cobranca de mensalidades, aulas avulsas e inscricoes em torneios. Toda comunicacao via **Supabase Edge Functions** (sem n8n).

## Configuracao

```env
ASAAS_API_KEY=your-api-key
ASAAS_ENVIRONMENT=sandbox  # sandbox | production
ASAAS_WEBHOOK_TOKEN=your-webhook-token
```

## Ambientes

| Ambiente | URL Base |
|----------|----------|
| Sandbox | `https://sandbox.asaas.com/api/v3` |
| Producao | `https://www.asaas.com/api/v3` |

## Edge Functions Envolvidas

| Edge Function | Tipo | Descricao |
|--------------|------|-----------|
| `asaas-webhook` | Webhook receptor | Recebe eventos do Asaas (pagamento, vencimento, cancelamento) |
| `asaas-create-customer` | Chamada do app | Cria cliente no Asaas |
| `asaas-create-payment` | DB trigger | Gera cobranca quando fatura e criada |
| `asaas-subscription` | Chamada do app | Gerencia assinatura da arena na plataforma |
| `cron-billing` | pg_cron diario | Gera faturas automaticamente D-3 do vencimento |
| `cron-overdue` | pg_cron diario | Follow-up de inadimplencia escalonado |

## Formas de Pagamento

| Forma | Suporte |
|-------|---------|
| PIX | QR Code gerado automaticamente |
| Boleto | Linha digitavel + PDF |
| Cartao de Credito | Tokenizacao no frontend |
| Cartao de Debito | Via checkout Asaas |

## Fluxo de Cobranca Completo

```
1. Fatura criada no sistema (manual ou cron-billing)
   └─> DB trigger dispara Edge Function "asaas-create-payment"
       └─> Busca credenciais da arena em integracao_asaas
           └─> Chama API Asaas: cria cobranca
               └─> Retorna payment_id, QR code, link boleto
                   └─> Atualiza fatura no banco
                       └─> Insere mensagem na fila_mensagens

2. Cliente paga
   └─> Asaas envia webhook para "asaas-webhook"
       └─> Edge Function valida token
           └─> Registra em webhook_events
               └─> Atualiza fatura (status: paga)
                   └─> Gera notificacao de confirmacao
                       └─> fila_mensagens envia WhatsApp + email

3. Cliente NAO paga
   └─> "cron-overdue" detecta fatura vencida
       └─> D+1: WhatsApp amigavel
       └─> D+3: WhatsApp + Email
       └─> D+7: Email formal
       └─> D+15: Suspende acesso
```

## Webhook Asaas

```
POST <SUPABASE_URL>/functions/v1/asaas-webhook
```

Eventos processados:
- `PAYMENT_RECEIVED` - Pagamento confirmado
- `PAYMENT_OVERDUE` - Pagamento vencido
- `PAYMENT_DELETED` - Pagamento cancelado
- `PAYMENT_REFUNDED` - Pagamento estornado

## Campos na Tabela `faturas`

| Campo | Descricao |
|-------|-----------|
| `asaas_payment_id` | ID do pagamento no Asaas |
| `asaas_invoice_url` | URL de pagamento para o cliente |
| `qr_code_pix` | QR Code PIX (base64 ou URL) |
| `linha_digitavel` | Linha digitavel do boleto |

## Tabelas Relacionadas

| Tabela | Uso |
|--------|-----|
| `integracao_asaas` | Credenciais por arena (//HIGH-RISK) |
| `faturas` | Faturas com campos Asaas |
| `webhook_events` | Log de webhooks recebidos |
| `fila_mensagens` | Fila de notificacoes |

---

**Proximos:** [WhatsApp](./whatsapp.md) | [Automacoes](./automations.md)
