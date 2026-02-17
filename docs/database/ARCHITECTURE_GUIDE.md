# Guia de Arquitetura e Negocio - Verana Beach Tennis

**Para:** Dono do Sistema (Voce!)
**Objetivo:** Entender TUDO que foi construido, como funciona, e o que cada peca faz

---

## 1. Visao Geral: O Que Voce Tem

Voce tem um **sistema SaaS completo** para gestao de arenas de beach tennis. Isso significa:

- **Voce** e o dono da plataforma (Super Admin)
- **Seus clientes** sao os donos de arenas de beach tennis
- **Os clientes dos seus clientes** sao os alunos, professores e funcionarios de cada arena

### Como um Hotel: Analogia Simples

Pense assim:
- **Voce** = dono da rede de hoteis (a marca, o sistema)
- **Arena** = cada hotel individual (cada cliente seu)
- **Alunos/Professores** = hospedes e funcionarios de cada hotel

Cada arena e completamente isolada — nenhuma arena ve os dados da outra.

---

## 2. Hierarquia de Usuarios

```
VOCE (Super Admin)
│
├── Dono da Arena A (arena_admin — pode ter varias arenas!)
│   ├── Funcionarios da Arena A
│   ├── Professores da Arena A
│   └── Alunos da Arena A
│
├── Dono da Arena B (arena_admin)
│   ├── Funcionarios da Arena B
│   ├── Professores da Arena B
│   └── Alunos da Arena B
│
└── ...quantas arenas quiser
```

### O Que Cada Tipo de Usuario Pode Fazer:

| Papel | Pode Fazer |
|-------|-----------|
| **Super Admin (Voce)** | TUDO: ver todas as arenas, metricas, receita, criar planos, enviar anuncios, suspender arenas |
| **Dono de Arena** | Gerencia completa da(s) sua(s) arena(s): quadras, agendamentos, financeiro, funcionarios, configuracoes |
| **Funcionario** | Operacoes do dia-a-dia: criar agendamentos, fazer check-ins, gerenciar quadras |
| **Professor** | Gerenciar suas aulas, avaliar alunos, ver seus horarios |
| **Aluno** | Ver e criar seus agendamentos, ver suas faturas, fazer check-in |

---

## 3. Funcionalidade: Multi-Arena (Novo!)

Um dono de arena pode gerenciar **multiplas arenas** com um unico login. Isso e feito pela tabela `usuarios_arenas`:

- Maria pode ser dona da Arena Copacabana E da Arena Ipanema
- Ela faz login UMA vez e pode trocar entre as arenas (switch de conta)
- Cada arena tem seus proprios dados, funcionarios, alunos, financeiro

### Como Funciona Tecnicamente:
- Tabela `usuarios_arenas` vincula usuario <-> arena com papel (proprietario, admin, etc.)
- Campo `arena_ativa = true` indica qual arena esta selecionada no momento
- No frontend, um seletor permite trocar entre arenas

---

## 4. Seu Painel de Controle (Super Admin)

### O Que Voce Ve e Controla:

| Area | Dados | Tabela |
|------|-------|--------|
| **Metricas SaaS** | MRR, ARR, churn rate, arenas ativas, trials, conversoes | `metricas_plataforma` |
| **Arenas** | Todas as arenas cadastradas, status, plano, inadimplencia | `arenas` |
| **Assinaturas** | Ciclo de vida: trial -> ativa -> inadimplente -> suspensa | `eventos_assinatura` |
| **Faturamento** | Faturas emitidas para cada arena, status de pagamento | `faturas_sistema` |
| **Planos** | Basico (R$39,90), Pro (R$89,90), Premium (R$159,90) | `planos_sistema` |
| **Modulos** | Quais modulos cada plano oferece | `modulos_sistema` + `arena_modulos` |
| **Webhooks** | Pagamentos recebidos via Asaas, reconciliacao | `webhook_events` |
| **Uso** | Quanto cada arena usa (usuarios, agendamentos, storage) | `uso_plataforma` |
| **Anuncios** | Comunicacao com donos de arenas (novidades, manutencao) | `anuncios_plataforma` |

### Ciclo de Vida da Assinatura:

```
TRIAL (14 dias gratis)
  │
  ├─ Converte -> ATIVA (pagamento recorrente)
  │   │
  │   ├─ Atrasa pagamento -> INADIMPLENTE
  │   │   │
  │   │   ├─ Paga -> ATIVA (volta ao normal)
  │   │   └─ Continua -> SUSPENSA (funcionalidade limitada)
  │   │       │
  │   │       ├─ Paga -> ATIVA
  │   │       └─ Desiste -> CANCELADA
  │   │
  │   └─ Cancela voluntariamente -> CANCELADA
  │
  └─ Nao converte -> CANCELADA
```

Cada transicao e registrada em `eventos_assinatura` para voce ter historico completo.

---

## 5. Planos e Precos

| Plano | Preco | Modulos Inclusos |
|-------|-------|-----------------|
| **Basico** | R$39,90/mes | Dashboard, Arenas, Quadras, Pessoas, Agendamentos, Financeiro basico |
| **Pro** | R$89,90/mes | Tudo do Basico + Aulas, Relatorios avancados, WhatsApp |
| **Premium** | R$159,90/mes | Tudo do Pro + Torneios, Eventos, Automacoes |

### Modulos do Sistema:

| # | Modulo | Descricao | Plano Min. |
|---|--------|-----------|-----------|
| 0 | Super Admin | Gestao da plataforma, planos, arenas | Plataforma |
| 1 | Arenas | Cadastro, config, customizacao visual | Basico |
| 2 | Quadras | Cadastro, bloqueios, manutencoes | Basico |
| 3 | Pessoas | Usuarios, professores, funcionarios | Basico |
| 4 | Agendamentos | Reservas, check-in (QR/GPS), recorrencia | Basico |
| 5 | Aulas | Tipos, matriculas, pacotes, reposicoes | Pro |
| 6 | Financeiro | Contratos, faturas, Asaas, comissoes | Basico/Pro |
| 7 | Torneios | Torneios, eventos, inscricoes, chaveamento | Premium |

---

## 6. Estrutura do Banco de Dados

### Numeros Exatos:

| Item | Quantidade |
|------|-----------|
| Tabelas | 76 |
| Tipos ENUM | 69 |
| Views (relatorios) | 5 |
| Policies RLS (seguranca) | ~130 |
| Triggers automaticos | ~58 |
| Indices de performance | ~50 |

### Tabelas por Area:

| Area | Qtd | Descricao |
|------|-----|-----------|
| Plataforma | 15 | Gestao SaaS: planos, arenas, assinaturas, metricas, webhooks |
| Usuarios | 4 | Usuarios, professores, funcionarios, permissoes |
| Quadras | 4 | Quadras, bloqueios, manutencoes, equipamentos |
| Agendamentos | 4 | Reservas, checkins, lista espera, recorrencia |
| Aulas | 7 | Tipos, aulas, matriculas, reposicoes, pacotes |
| Financeiro | 7 | Planos, contratos, faturas, comissoes, fluxo de caixa |
| Torneios | 7 | Torneios, inscricoes, chaveamento, partidas, resultados, eventos |
| Comunicacao | 16 | Notificacoes, campanhas, templates, WhatsApp, Asaas, automacoes, fila, chatbot, insights |
| Config/Auditoria | 12 | Configuracoes, logs, auditoria, sessoes, historico |

---

## 7. Seguranca: Como Seus Dados Estao Protegidos

### Isolamento por Arena (Multi-tenant)

Cada arena so ve seus proprios dados. Isso e garantido pelo **Row Level Security (RLS)** do PostgreSQL — nao e apenas uma regra de aplicacao, e uma regra do BANCO DE DADOS. Mesmo que alguem tente acessar diretamente o banco, so vera dados da sua arena.

### Funcoes de Seguranca:

| Funcao | O Que Faz |
|--------|----------|
| `auth_user_arena_id()` | Retorna qual arena o usuario logado pertence |
| `auth_user_role()` | Retorna o papel do usuario (admin, professor, aluno...) |
| `auth_user_id()` | Retorna o ID do usuario logado |
| `is_super_admin()` | Verifica se voce e o dono da plataforma |
| `auth_user_arena_ids()` | Retorna TODAS as arenas de um usuario multi-arena |
| `is_arena_proprietario()` | Verifica se e proprietario de uma arena especifica |

### Auditoria Automatica:

Todas as mudancas em tabelas criticas (usuarios, agendamentos, faturas, quadras, aulas, contratos, torneios) sao **automaticamente registradas** na tabela `auditoria_dados`. Voce sabe:
- Quem mudou
- O que mudou (valor antigo e novo)
- Quando mudou
- De onde (web, mobile, API)

---

## 8. Integracoes Externas e Automacoes

| Servico | Para Que | Tabela de Config |
|---------|---------|-----------------|
| **Asaas** | Pagamentos (PIX, boleto, cartao) | `integracao_asaas` |
| **Evolution API** | WhatsApp (envio automatico + chatbot AI) | `integracao_whatsapp` |
| **Claude AI** | Chatbot WhatsApp + insights de negocio | `chatbot_conversas`, `insights_arena` |
| **Resend** | Email transacional | via Edge Functions |
| **Supabase Auth** | Login e autenticacao | nativo Supabase |

### Como as Automacoes Funcionam (Sem n8n!)

Todas as automacoes sao feitas DENTRO do Supabase, usando:

1. **Edge Functions** — pequenos programas que rodam no servidor (14+ funcoes)
2. **pg_cron** — agendador de tarefas (como um despertador para o banco de dados)
3. **pg_net** — permite o banco de dados fazer chamadas HTTP

**Exemplos praticos:**
- Aluno agenda uma aula → banco de dados detecta → Edge Function envia WhatsApp de confirmacao
- Todo dia as 06:00 → pg_cron roda → Edge Function verifica faturas vencendo → envia lembretes
- Aluno envia mensagem pelo WhatsApp → Edge Function recebe → AI (Claude) responde automaticamente

### Fila de Mensagens (Rate Limit):

WhatsApp tem limite de ~30 mensagens por minuto. O sistema resolve isso com uma **fila inteligente**:
1. Toda mensagem que precisa ser enviada vai para `fila_mensagens`
2. A cada 1 minuto, um cron job processa no maximo 30 mensagens
3. Se der erro, tenta novamente (max 3 tentativas)
4. Tudo fica registrado em `historico_comunicacoes`

### AI Chatbot (WhatsApp):

O sistema tem um chatbot inteligente que atende seus alunos via WhatsApp:
- Aluno pergunta sobre horarios → AI busca e responde
- Aluno quer agendar → AI oferece opcoes disponiveis
- Aluno quer cancelar → AI processa o cancelamento
- Pergunta complexa → AI escala para atendente humano
- Custo estimado: ~R$0,005 por mensagem (muito barato!)

### Webhooks (Asaas -> Seu Sistema):

Quando um pagamento e recebido no Asaas, ele envia um webhook para o sistema. A tabela `webhook_events` registra:
- Qual provider enviou (Asaas)
- Tipo do evento (pagamento recebido, recusado, etc.)
- Payload completo
- Status de processamento (recebido -> processando -> processado)
- Tentativas em caso de erro (max 3)

---

## 9. White-Label: Personalizacao por Arena

Cada arena pode ter sua propria identidade visual:

| Campo | Descricao |
|-------|-----------|
| `nome` | Nome da arena |
| `logo_url` | Logo customizado |
| `cores_tema` | Cores primaria e secundaria |
| `subdomain` | Ex: `arenacopacabana.verana.com.br` |
| `custom_domain` | Ex: `www.arenacopacabana.com.br` |
| `favicon_url` | Icone do navegador |
| `email_remetente` | Email de envio customizado |

---

## 10. Fluxo de Dados: Do Trial ao Cliente Ativo

```
1. Nova arena se cadastra (status: trial, 14 dias gratis)
2. Sistema cria arena + usuario arena_admin + configuracoes padrao
3. Arena configura: quadras, horarios, precos, integracao Asaas
4. Trial expira: sistema envia cobranca (Asaas webhook)
5. Arena paga: status muda para "ativa"
6. Arena opera: agendamentos, aulas, financeiro, tudo funcionando
7. Voce monitora: metricas_plataforma mostra MRR, churn, crescimento
```

---

## 11. Arquivos SQL: Mapa Completo

```
supabase/migrations/
│
├── 001_extensions_and_config.sql    # Extensoes PostgreSQL
├── 002_enums.sql                    # 65 tipos de dados
├── 003_platform_tables.sql          # Planos, arenas (SUA gestao)
├── 004_users_tables.sql             # Usuarios do sistema
├── 005_courts_tables.sql            # Quadras
├── 006_scheduling_tables.sql        # Agendamentos + check-in
├── 007_classes_tables.sql           # Aulas
├── 008_financial_tables.sql         # Financeiro (faturas, contratos)
├── 009_tournaments_tables.sql       # Torneios e eventos
├── 010_communication_tables.sql     # WhatsApp, notificacoes, campanhas
├── 011_config_and_audit_tables.sql  # Config + auditoria + logs
├── 012_rls_policies.sql             # SEGURANCA (quem ve o que)
├── 013_triggers_and_functions.sql   # Automacoes do banco
├── 014_indexes.sql                  # Performance
├── 015_views.sql                    # Relatorios prontos
├── 016_seeds.sql                    # Dados iniciais (planos, modulos)
├── 017_platform_enhancements.sql    # Multi-arena, trial, metricas
├── 018_platform_rls_triggers_indexes.sql  # Seguranca das tabelas novas
├── 019_edge_functions_support.sql   # Edge Functions, fila, chatbot AI, insights
├── 020_edge_functions_rls_triggers_indexes.sql  # Seguranca das tabelas de automacao
└── 021_infrastructure_auth_storage_seeds.sql    # Login automatico, storage, templates, pagamentos
```

---

## 12. Proximo Passo: Frontend

O banco de dados esta **pronto para execucao**. O proximo passo e:

1. **Executar os migrations** no Supabase (siga `supabase/GUIA_EXECUCAO.md`)
2. **Criar o projeto Next.js** (frontend web)
3. **Conectar ao Supabase** (URL + chaves)
4. **Implementar as telas** (dashboard, login, agendamentos, etc.)
5. **Deploy das Edge Functions** (14+ funcoes de automacao)
6. **Configurar integracoes** (Asaas, WhatsApp, Claude AI)
7. **Deploy na Vercel** (publicar o site)

---

## 13. Glossario

| Termo | Significado |
|-------|-----------|
| **SaaS** | Software as a Service — sistema que voce cobra mensalidade |
| **Multi-tenant** | Multiplos clientes no mesmo sistema, isolados |
| **White-label** | Cada cliente ve como se fosse o sistema dele |
| **RLS** | Row Level Security — seguranca no nivel do banco de dados |
| **ENUM** | Tipo de dado com valores fixos (ex: status so pode ser "ativo" ou "inativo") |
| **GENERATED column** | Coluna calculada automaticamente pelo banco |
| **Trigger** | Acao automatica que roda quando algo muda no banco |
| **MRR** | Monthly Recurring Revenue — receita mensal recorrente |
| **ARR** | Annual Recurring Revenue — receita anual recorrente |
| **Churn** | Taxa de cancelamento de clientes |
| **Trial** | Periodo de teste gratuito |
| **Webhook** | Notificacao automatica entre sistemas |
| **Junction table** | Tabela que conecta duas outras tabelas (ex: usuario <-> arena) |
| **Edge Function** | Funcao que roda no servidor do Supabase (substitui o n8n) |
| **pg_cron** | Agendador de tarefas do PostgreSQL (roda coisas em horarios fixos) |
| **pg_net** | Extensao que permite o banco fazer chamadas HTTP |
| **Chatbot AI** | Robo inteligente que conversa com alunos via WhatsApp |
| **Claude** | Inteligencia artificial da Anthropic usada no chatbot e insights |

---

**Referencia tecnica completa:** [Schemas SQL](./schemas.md) | [Seguranca e RLS](./rls-and-security.md) | [Guia de Execucao](../../supabase/GUIA_EXECUCAO.md)
