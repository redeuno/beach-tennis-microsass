# Automacoes - n8n

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Premium

---

## Visao Geral

Workflows automatizados via n8n para comunicacao, cobranca e lembretes.

## Fluxos Principais

### 1. Confirmacao de Agendamento
- **Trigger:** Novo agendamento criado (webhook do Supabase)
- **Acoes:** Enviar WhatsApp + Email + SMS
- **Tempo:** Imediato

### 2. Lembrete de Aula
- **Trigger:** Schedule (cron)
- **Acoes:** Buscar aulas nas proximas 2h, enviar WhatsApp para aluno e professor
- **Tempo:** 2h antes da aula

### 3. Cobranca Automatica
- **Trigger:** Schedule (diario)
- **Acoes:** Verificar faturas vencendo, gerar cobranca no Asaas, notificar cliente
- **Tempo:** D-3 do vencimento

### 4. Follow-up Inadimplencia
- **Trigger:** Fatura vencida (webhook)
- **Acoes:** Serie de mensagens escalonadas
- **Cronograma:**
  - D+1: Lembrete amigavel (WhatsApp)
  - D+3: Segundo lembrete (WhatsApp + Email)
  - D+7: Notificacao formal (Email)
  - D+15: Suspensao de acesso

### 5. Aniversariantes
- **Trigger:** Schedule (diario)
- **Acoes:** Buscar aniversariantes do dia, enviar mensagem personalizada
- **Tempo:** 08:00

## Arquitetura

```
Supabase (evento) -> Webhook -> n8n -> Acoes (WhatsApp/Email/Asaas)
                                  └-> Supabase (atualizar status)
```

## Webhooks do Supabase

Configurar Database Webhooks para disparar automacoes:

| Tabela | Evento | URL n8n |
|--------|--------|---------|
| agendamentos | INSERT | /webhook/agendamento-criado |
| agendamentos | UPDATE (status) | /webhook/agendamento-atualizado |
| faturas | INSERT | /webhook/fatura-criada |
| faturas | UPDATE (status=vencida) | /webhook/fatura-vencida |

---

**Proximos:** [WhatsApp](./whatsapp.md) | [Asaas](./asaas.md)
