# Integracao WhatsApp - Evolution API + AI Chatbot

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Pro (mensagens) | Premium (AI chatbot)

---

## Visao Geral

Integracao com WhatsApp via Evolution API para envio de mensagens automaticas, manuais e **chatbot com AI** (Claude). Toda logica via Edge Functions.

## Configuracao

```env
EVOLUTION_API_URL=https://your-evolution-api.com
EVOLUTION_API_KEY=your-api-key
ANTHROPIC_API_KEY=sk-ant-...  # Para AI chatbot
```

## Edge Functions Envolvidas

| Edge Function | Tipo | Descricao |
|--------------|------|-----------|
| `whatsapp-send` | Chamada interna | Envia mensagem via Evolution API |
| `whatsapp-webhook` | Webhook receptor | Recebe mensagens + processa com AI |
| `cron-process-queue` | pg_cron | Processa fila respeitando rate limit |
| `cron-reminders` | pg_cron | Insere lembretes na fila |
| `cron-birthday` | pg_cron | Mensagens de aniversario |

## Mensagens Automaticas

| Trigger | Mensagem | Quando |
|---------|----------|--------|
| Novo agendamento | Confirmacao com detalhes | Imediato (via fila) |
| Lembrete de aula | Lembrete ao aluno e professor | 2h antes |
| Fatura vencendo | Lembrete de pagamento | 3 dias antes |
| Fatura vencida | Cobranca escalonada | 1, 3, 7 dias apos |
| Cancelamento | Confirmacao de cancelamento | Imediato |
| Aniversario | Parabens personalizado | 08:00 |
| Pagamento confirmado | Confirmacao de recebimento | Imediato |

## AI Chatbot — Como Funciona

```
Aluno envia mensagem via WhatsApp
  └─> Evolution API envia webhook
       └─> Edge Function "whatsapp-webhook"
            └─> Identifica arena pelo numero
                 └─> Busca/cria conversa (chatbot_conversas)
                      └─> Monta contexto para AI:
                           - Ultimas 10 mensagens
                           - Dados do cliente
                           - Horarios disponiveis
                           - Politicas da arena
                      └─> Claude Haiku detecta intent:
                           ├─ "agendar" → Busca horarios, oferece opcoes
                           ├─ "cancelar" → Processa cancelamento
                           ├─ "preco" → Mostra planos e valores
                           ├─ "fatura" → Envia link de pagamento
                           ├─ "horario" → Mostra agenda
                           └─ complexo → Escala para atendente humano
```

### Escalacao para Humano

Quando o chatbot nao consegue resolver:
1. Marca `escalado_para_humano = true` em `chatbot_conversas`
2. Notifica atendente da arena (funcionario/admin)
3. Atendente responde via dashboard do sistema
4. Resposta e enviada via `whatsapp-send`

## Fila de Mensagens (Rate Limit)

WhatsApp tem rate limit (~30 msg/min). A `fila_mensagens` resolve:

1. Edge Functions inserem mensagens com status `pendente`
2. `cron-process-queue` roda a cada 1 minuto
3. Processa max 30 mensagens WhatsApp por execucao
4. Em caso de erro: retry automatico (max 3 tentativas)
5. Resultado registrado em `historico_comunicacoes`

## Templates de Mensagem

Gerenciados via tabela `templates_whatsapp`:
- Cada arena configura seus templates
- Variaveis dinamicas: `{nome}`, `{data}`, `{horario}`, `{valor}`, `{link}`
- Templates pre-configurados na instalacao

## Webhook (Mensagens Recebidas)

```
POST <SUPABASE_URL>/functions/v1/whatsapp-webhook
```

Processa respostas dos clientes e direciona para AI ou atendente.

## Tabelas Relacionadas

| Tabela | Uso |
|--------|-----|
| `integracao_whatsapp` | Credenciais por arena (//HIGH-RISK) |
| `templates_whatsapp` | Templates de mensagem |
| `fila_mensagens` | Fila com rate limiting |
| `chatbot_conversas` | Conversas AI ativas |
| `chatbot_mensagens` | Mensagens individuais com intent |
| `historico_comunicacoes` | Log de tudo enviado |

---

**Proximos:** [Asaas](./asaas.md) | [AI Integration](./ai-integration.md) | [Automacoes](./automations.md)
