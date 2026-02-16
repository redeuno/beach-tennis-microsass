# Automacoes - Supabase Edge Functions + pg_cron

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Basico (automacoes core) | Pro (WhatsApp) | Premium (AI)

---

## Visao Geral

Todas as automacoes rodam nativamente no Supabase via **Edge Functions** (Deno) + **pg_cron** (agendamento) + **pg_net** (HTTP). Sem dependencia externa de n8n ou qualquer outro orchestrator.

## Arquitetura

```
EVENTO NO BANCO (insert/update)
  └─> Database Trigger (PL/pgSQL)
       └─> pg_net.http_post() ──> Edge Function ──> API Externa
                                        │              (Asaas, WhatsApp, Email)
                                        └──> Atualiza banco

AGENDAMENTO (cron)
  └─> pg_cron (extensao PostgreSQL)
       └─> pg_net.http_post() ──> Edge Function ──> Logica + APIs

WEBHOOK EXTERNO (Asaas/WhatsApp manda pra nos)
  └─> Edge Function (endpoint HTTP publico)
       └─> Processa payload ──> Atualiza banco
```

## Edge Functions por Categoria

### A. Pagamentos (Asaas) — //HIGH-RISK

| Edge Function | Trigger | O que faz |
|--------------|---------|-----------|
| `asaas-webhook` | Webhook externo POST | Recebe eventos do Asaas, atualiza faturas, registra webhook_events |
| `asaas-create-customer` | Chamada do app | Cria cliente no Asaas |
| `asaas-create-payment` | DB trigger (fatura INSERT) | Gera cobranca PIX/boleto/cartao |
| `asaas-subscription` | Chamada do app | Gerencia assinatura da arena |

### B. Comunicacao (WhatsApp + Email)

| Edge Function | Trigger | O que faz |
|--------------|---------|-----------|
| `whatsapp-send` | Chamada interna | Envia mensagem via Evolution API |
| `whatsapp-webhook` | Webhook externo POST | Recebe mensagens, processa com AI chatbot |
| `email-send` | Chamada interna | Envia email via Resend |
| `notification-dispatch` | DB trigger (notificacao INSERT) | Despacha pelo canal correto |

### C. Automacoes Agendadas (pg_cron)

| Edge Function | Cron | O que faz |
|--------------|------|-----------|
| `cron-billing` | Diario 06:00 | Gera faturas, cria cobranças Asaas D-3 |
| `cron-reminders` | A cada 30min | Lembretes: aula 2h, fatura 3 dias, agendamento amanha |
| `cron-overdue` | Diario 09:00 | Cobranca escalonada: D+1, D+3, D+7, D+15 |
| `cron-lifecycle` | Diario 00:30 | Expira trials, marca inadimplentes, gera metricas |
| `cron-process-queue` | A cada 1min | Processa fila de mensagens (rate limit safe) |
| `cron-ai-insights` | Diario 05:00 | Gera insights por AI para arenas ativas |
| `cron-birthday` | Diario 08:00 | Mensagens de aniversario |

### D. Eventos de Negocio (DB triggers)

| Edge Function | Trigger | O que faz |
|--------------|---------|-----------|
| `on-agendamento` | DB trigger (agendamento INSERT/UPDATE) | Confirmacao WhatsApp + email |
| `on-arena-created` | DB trigger (arena INSERT) | Setup inicial + boas-vindas + trial |

## Fluxos Detalhados

### 1. Confirmacao de Agendamento
```
Aluno cria agendamento
  └─> DB trigger on agendamentos INSERT
       └─> Edge Function "on-agendamento"
            ├─> Insere na fila_mensagens (WhatsApp + Email)
            └─> "cron-process-queue" envia na proxima execucao
```

### 2. Cobranca Automatica
```
pg_cron dispara "cron-billing" (06:00)
  └─> Query contratos ativos com vencimento em D-3
       └─> Para cada: gera fatura no banco
            └─> DB trigger chama "asaas-create-payment"
                 └─> Cria cobranca no Asaas (PIX/boleto)
                      └─> Salva asaas_payment_id na fatura
                           └─> Insere lembrete na fila_mensagens
```

### 3. Follow-up Inadimplencia
```
pg_cron dispara "cron-overdue" (09:00)
  └─> Query faturas vencidas
       ├─> D+1: WhatsApp amigavel
       ├─> D+3: WhatsApp + Email
       ├─> D+7: Email formal
       └─> D+15: Suspende acesso (UPDATE usuario.status)
```

### 4. AI Chatbot WhatsApp
```
Mensagem recebida via Evolution API
  └─> Edge Function "whatsapp-webhook"
       └─> Identifica arena pelo numero
            └─> Busca/cria conversa em chatbot_conversas
                 └─> Envia para Claude API com contexto
                      ├─> Intent "agendar" → busca horarios, responde
                      ├─> Intent "cancelar" → processa cancelamento
                      ├─> Intent "preco" → busca planos, responde
                      └─> Complexo → escala para humano
```

## Fila de Mensagens

A tabela `fila_mensagens` funciona como message queue:

1. Qualquer Edge Function insere mensagem com status `pendente`
2. `cron-process-queue` roda a cada 1 minuto
3. Processa em batch respeitando rate limits:
   - WhatsApp: max 30 msg/min por instancia
   - Email: max 100/min (Resend)
4. Em caso de erro, incrementa `tentativas` (max 3)
5. Registra resultado em `historico_comunicacoes`

## Tabela de Referencia: cron_jobs_config

Todos os cron jobs planejados estao registrados na tabela `cron_jobs_config` com:
- Nome e descricao
- Expressao cron
- Nome da Edge Function correspondente
- Status ativo/inativo

Os jobs sao ativados via `SELECT cron.schedule()` apos deploy das Edge Functions.

---

**Proximos:** [Edge Functions Spec](./edge-functions.md) | [WhatsApp](./whatsapp.md) | [Asaas](./asaas.md)
