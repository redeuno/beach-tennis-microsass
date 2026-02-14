# Integracao WhatsApp - Evolution API

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Pro

---

## Visao Geral

Integracao com WhatsApp via Evolution API para envio de mensagens automaticas e manuais.

## Configuracao

```env
EVOLUTION_API_URL=https://your-evolution-api.com
EVOLUTION_API_KEY=your-api-key
EVOLUTION_INSTANCE_NAME=verana-instance
```

## Servico

```typescript
// lib/services/whatsapp.ts
export class WhatsAppService {
  async sendMessage(to: string, message: string): Promise<void>
  async sendAgendamentoConfirmation(agendamento: Agendamento): Promise<void>
  async sendPaymentReminder(fatura: Fatura): Promise<void>
}
```

## Mensagens Automaticas

| Trigger | Mensagem | Quando |
|---------|----------|--------|
| Novo agendamento | Confirmacao com detalhes | Imediato |
| Lembrete de aula | Lembrete ao aluno e professor | 2h antes |
| Fatura vencendo | Lembrete de pagamento | 3 dias antes |
| Fatura vencida | Cobranca | 1, 3, 7 dias apos |
| Cancelamento | Confirmacao de cancelamento | Imediato |

## Templates de Mensagem

Gerenciados via tabela `templates_comunicacao`:

```sql
CREATE TABLE templates_comunicacao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(100) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  canal VARCHAR(20) NOT NULL, -- whatsapp, email, sms
  assunto VARCHAR(200),
  conteudo TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Webhook (Mensagens Recebidas)

```
POST /api/webhooks/whatsapp
```

Processsa respostas dos clientes (ex: "CANCELAR" para cancelar agendamento).

---

**Proximos:** [Asaas](./asaas.md) | [Automacoes](./automations.md)
