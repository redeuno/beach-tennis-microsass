# Integracao Asaas - Pagamentos

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Basico (parcial) | Pro (completo)

---

## Visao Geral

Plataforma de pagamentos para cobranca de mensalidades, aulas avulsas e inscricoes em torneios.

## Configuracao

```env
ASAAS_API_KEY=your-api-key
ASAAS_ENVIRONMENT=sandbox  # sandbox | production
```

## Ambientes

| Ambiente | URL Base |
|----------|----------|
| Sandbox | `https://sandbox.asaas.com/api/v3` |
| Producao | `https://www.asaas.com/api/v3` |

## Servico

```typescript
// lib/services/asaas.ts
export class AsaasService {
  async createCustomer(customerData): Promise<AsaasCustomer>
  async createPayment(paymentData): Promise<AsaasPayment>
  async getPayment(paymentId: string): Promise<AsaasPayment>
  async cancelPayment(paymentId: string): Promise<void>
  async createSubscription(subscriptionData): Promise<AsaasSubscription>
}
```

## Formas de Pagamento

| Forma | Suporte |
|-------|---------|
| PIX | QR Code gerado automaticamente |
| Boleto | Linha digitavel + PDF |
| Cartao de Credito | Tokenizacao no frontend |
| Cartao de Debito | Via checkout Asaas |

## Fluxo de Cobranca

1. Cliente criado no Asaas (`createCustomer`)
2. Fatura gerada no sistema (`faturas`)
3. Cobranca criada no Asaas (`createPayment`)
4. `asaas_payment_id` salvo na fatura
5. Webhook recebe atualizacao de status
6. Fatura atualizada no sistema

## Webhook

```
POST /api/webhooks/asaas
```

Eventos processados:
- `PAYMENT_RECEIVED` - Pagamento confirmado
- `PAYMENT_OVERDUE` - Pagamento vencido
- `PAYMENT_DELETED` - Pagamento cancelado

## Campos na Tabela `faturas`

| Campo | Descricao |
|-------|-----------|
| `asaas_payment_id` | ID do pagamento no Asaas |
| `asaas_invoice_url` | URL de pagamento para o cliente |
| `qr_code_pix` | QR Code PIX (base64 ou URL) |
| `linha_digitavel` | Linha digitavel do boleto |

---

**Proximos:** [WhatsApp](./whatsapp.md) | [Automacoes](./automations.md)
