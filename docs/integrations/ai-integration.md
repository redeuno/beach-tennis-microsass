# Integracao com AI — Claude API

[<- Voltar ao Indice](../README.md)

**Plano minimo:** Pro (chatbot basico) | Premium (insights + analises)

---

## Visao Geral

AI integrada via Claude API (Anthropic) para chatbot WhatsApp, insights automaticos e assistente de gestao. Toda logica roda em Edge Functions.

## Features AI por Prioridade

### Alta Prioridade

| # | Feature | Edge Function | Modelo | Custo Est. |
|---|---------|--------------|--------|-----------|
| 1 | **Chatbot WhatsApp** | `whatsapp-webhook` | Claude Haiku | ~$0.001/msg |
| 2 | **Insights do Dashboard** | `cron-ai-insights` | Claude Sonnet | ~$0.003/insight |
| 3 | **Gerador de Campanhas** | via app (API route) | Claude Sonnet | ~$0.005/campanha |

### Media Prioridade

| # | Feature | Onde | Modelo |
|---|---------|------|--------|
| 4 | Sugestao de horarios | Agendamento | Claude Haiku |
| 5 | Predicao de churn | `cron-lifecycle` | Claude Haiku |
| 6 | Resumo financeiro | Dashboard | Claude Sonnet |

### Baixa Prioridade (futuro)

| # | Feature | Onde |
|---|---------|------|
| 7 | Otimizacao de precos | Dashboard Admin |
| 8 | Classificacao de alunos | Evolucao |
| 9 | Deteccao de anomalias | Auditoria |
| 10 | Geracao de planos de aula | Aulas |

## Chatbot WhatsApp — Detalhamento

### Fluxo
```
Mensagem do aluno via WhatsApp
  └─> Evolution API envia webhook
       └─> Edge Function "whatsapp-webhook"
            └─> Identifica arena + cliente
                 └─> Monta contexto (mensagens + dados + horarios)
                 └─> Chama Claude Haiku com system prompt
                      └─> Detecta intent e executa acao
                           ├─ "agendar" → Query horarios → Responde
                           ├─ "cancelar" → Processa → Confirma
                           ├─ "preco" → Query planos → Responde
                           └─ complexo → Escala para humano
```

### Tabelas Envolvidas

| Tabela | Uso |
|--------|-----|
| `chatbot_conversas` | Estado da conversa (ativa, escalada, contexto) |
| `chatbot_mensagens` | Cada mensagem com intent detectado e acao |
| `integracao_whatsapp` | Credenciais da Evolution API da arena |
| `templates_whatsapp` | Templates de resposta pre-configurados |

## Insights Automaticos

`cron-ai-insights` roda diariamente e gera insights acionaveis:

| Tipo | Exemplo |
|------|---------|
| `ocupacao` | "Sextas tem 40% menos agendamentos. Promova horarios." |
| `financeiro` | "3 alunos com 2+ faturas atrasadas. Contato pode evitar churn." |
| `crescimento` | "12 alunos novos este mes, 50% acima da media." |
| `retencao` | "Maria Silva sumiu ha 3 semanas. Risco de cancelamento." |

## Custo Estimado

| Feature | Uso Medio | Custo/mes/arena |
|---------|----------|-----------------|
| Chatbot (100 msg/dia) | 3.000 msg | ~$3.00 |
| Insights (1/dia) | 30 analises | ~$0.09 |
| Campanhas (2/semana) | 8 geracoes | ~$0.04 |
| **Total** | | **~$3-5** |

---

**Proximos:** [Edge Functions](./edge-functions.md) | [Automacoes](./automations.md)
