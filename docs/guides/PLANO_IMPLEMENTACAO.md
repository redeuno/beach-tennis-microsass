# PLANO DE IMPLEMENTACAO — Verana Beach Tennis

**Para:** Voce (dono do projeto, nao-dev)
**Modo:** Etapa por etapa — so avancamos quando voce validar que esta OK
**Consultor:** Arquiteto Fullstack Vibe Coding

---

## Como Funciona Este Plano

1. Cada **ETAPA** tem passos claros, com explicacao do que e e por que
2. No final de cada etapa, tem um **CHECKPOINT** — o que voce deve ver/testar
3. **So avancamos** para a proxima etapa quando voce confirmar que esta OK
4. Se algo der errado, paramos, analisamos e corrigimos ANTES de continuar
5. Tempo estimado total: **10-14 semanas** (trabalhando juntos)

---

## MAPA GERAL (10 Etapas)

```
ETAPA 1: Criar Projeto no Supabase (banco de dados)          [~30 min]
ETAPA 2: Executar os 20 SQL Migrations                        [~1 hora]
ETAPA 3: Criar Projeto Next.js (frontend web)                 [~1 hora]
ETAPA 4: Auth + Login + Onboarding                            [~1 semana]
ETAPA 5: Dashboard + Gestao de Arenas + Quadras               [~2 semanas]
ETAPA 6: Agendamentos + Calendario + Check-in                 [~2 semanas]
ETAPA 7: Financeiro + Integracao Asaas (pagamentos)           [~2 semanas]
ETAPA 8: Aulas + Torneios                                     [~2 semanas]
ETAPA 9: WhatsApp + AI Chatbot + Edge Functions               [~2 semanas]
ETAPA 10: Deploy na Vercel + Go Live                          [~3 dias]
```

---

## ETAPA 1: Criar Projeto no Supabase

**O que e:** Supabase e onde fica seu banco de dados (todas as tabelas, seguranca, etc). Pense nele como o "cerebro" do sistema.

**O que voce precisa:**
- Um navegador (Chrome/Firefox)
- Uma conta Google ou GitHub (para login no Supabase)

### Passos:

**1.1** Acesse https://supabase.com e clique em **"Start your project"**

**1.2** Faca login com sua conta Google ou GitHub

**1.3** Clique em **"New Project"** e preencha:
| Campo | O que colocar |
|-------|--------------|
| **Organization** | Crie uma nova ou use a existente |
| **Name** | `verana-beach-tennis` |
| **Database Password** | Uma senha forte (GUARDE EM LUGAR SEGURO!) |
| **Region** | `South America (Sao Paulo)` |
| **Pricing Plan** | Free (para comecar) |

**1.4** Clique em **"Create new project"** e aguarde 2-3 minutos

**1.5** Quando o projeto estiver criado, va em **Settings > API** e copie:
- **Project URL** (algo como `https://xyzabc.supabase.co`)
- **anon public** key
- **service_role** key (SECRETA — nunca compartilhe!)

**1.6** Guarde essas 3 informacoes em um local seguro (ex: bloco de notas privado)

### CHECKPOINT ETAPA 1:
- [ ] Projeto `verana-beach-tennis` criado no Supabase
- [ ] Dashboard do Supabase aberto e funcionando
- [ ] 3 credenciais salvas (URL, anon key, service_role key)
- [ ] Region = Sao Paulo

**Quando estiver OK, me avise: "Etapa 1 OK"**

---

## ETAPA 2: Executar os 20 SQL Migrations

**O que e:** Vamos criar todas as 76 tabelas, 69 tipos de dados, seguranca, e tudo mais no seu banco de dados. E como montar a estrutura de um predio — cada migration e um andar.

**IMPORTANTE:** Siga a ordem EXATA. Se der erro, PARE e me avise.

### Passos:

**2.1** No Supabase, clique em **"SQL Editor"** no menu lateral (icone `<>`)

**2.2** Para CADA arquivo abaixo, faca:
1. Abra o arquivo no seu computador (pasta `supabase/migrations/`)
2. Selecione TODO o conteudo (Ctrl+A)
3. Copie (Ctrl+C)
4. No SQL Editor, cole (Ctrl+V)
5. Clique **"Run"** (botao verde, ou Ctrl+Enter)
6. Espere a mensagem verde de sucesso
7. **APAGUE** o conteudo antes do proximo arquivo

### Ordem de Execucao:

| # | Arquivo | Tempo | O que cria |
|---|---------|-------|-----------|
| 1 | `001_extensions_and_config.sql` | ~5s | Extensoes do PostgreSQL |
| 2 | `002_enums.sql` | ~5s | 59 tipos de dados |
| 3 | `003_platform_tables.sql` | ~5s | Planos e arenas |
| 4 | `004_users_tables.sql` | ~5s | Usuarios |
| 5 | `005_courts_tables.sql` | ~5s | Quadras |
| 6 | `006_scheduling_tables.sql` | ~5s | Agendamentos |
| 7 | `007_classes_tables.sql` | ~5s | Aulas |
| 8 | `008_financial_tables.sql` | ~5s | Financeiro |
| 9 | `009_tournaments_tables.sql` | ~5s | Torneios |
| 10 | `010_communication_tables.sql` | ~5s | Comunicacao |
| 11 | `011_config_and_audit_tables.sql` | ~5s | Config e auditoria |
| 12 | `012_rls_policies.sql` | ~10s | Seguranca (RLS) |
| 13 | `013_triggers_and_functions.sql` | ~5s | Automacoes do banco |
| 14 | `014_indexes.sql` | ~5s | Performance |
| 15 | `015_views.sql` | ~5s | Relatorios |
| 16 | `016_seeds.sql` | ~5s | Dados iniciais |
| 17 | `017_platform_enhancements.sql` | ~5s | Multi-arena e metricas |
| 18 | `018_platform_rls_triggers_indexes.sql` | ~5s | Seguranca multi-arena |
| 19 | `019_edge_functions_support.sql` | ~5s | Chatbot AI e fila |
| 20 | `020_edge_functions_rls_triggers_indexes.sql` | ~5s | Seguranca chatbot |

**2.3** Apos executar TODOS os 20, rode este SQL de verificacao:

```sql
-- Deve retornar 76
SELECT COUNT(*) as total_tabelas
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE';

-- Deve retornar 69
SELECT COUNT(*) as total_enums
FROM pg_type
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
AND typtype = 'e';
```

### CHECKPOINT ETAPA 2:
- [ ] Todos os 20 arquivos executados sem erro
- [ ] Query de verificacao retorna: 76 tabelas
- [ ] Query de verificacao retorna: 69 ENUMs
- [ ] No menu lateral **"Table Editor"** voce ve varias tabelas listadas

**Se algum arquivo der erro:** Me envie a mensagem de erro EXATA (screenshot ou copie o texto). Nao prossiga.

**Quando estiver OK, me avise: "Etapa 2 OK"**

---

## ETAPA 3: Criar Projeto Next.js (Frontend Web)

**O que e:** Agora vamos criar o "visual" do sistema — as telas que seus clientes vao usar. Next.js e a ferramenta que transforma codigo em um site bonito e rapido.

**O que voce precisa:**
- **Node.js** instalado (versao 18+) — baixar em https://nodejs.org
- **VS Code** instalado (editor de codigo) — baixar em https://code.visualstudio.com
- Um terminal/prompt de comando

### Passos:

**3.1** Verificar se Node.js esta instalado:
```bash
node --version
# Deve mostrar algo como v18.x.x ou v20.x.x
```

Se nao estiver, instale pelo site https://nodejs.org (baixe a versao LTS)

**3.2** Eu vou criar a estrutura do projeto Next.js para voce.

O que sera criado:
```
src/
├── app/                          # Paginas do sistema
│   ├── (auth)/                   # Telas de login/registro
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (dashboard)/              # Telas do painel (logado)
│   │   ├── layout.tsx            # Layout com menu lateral
│   │   ├── page.tsx              # Dashboard principal
│   │   ├── arenas/               # Gestao de arenas
│   │   ├── quadras/              # Gestao de quadras
│   │   ├── agendamentos/         # Agendamentos
│   │   ├── pessoas/              # Usuarios/professores
│   │   ├── financeiro/           # Faturas/contratos
│   │   ├── aulas/                # Gestao de aulas
│   │   └── torneios/             # Torneios/eventos
│   ├── (super-admin)/            # Painel do dono (VOCE)
│   │   ├── layout.tsx
│   │   ├── page.tsx              # Metricas MRR/churn
│   │   ├── arenas/               # Todas as arenas
│   │   └── planos/               # Gestao de planos
│   ├── layout.tsx                # Layout raiz
│   └── page.tsx                  # Landing page
├── components/                   # Componentes reutilizaveis
│   ├── ui/                       # Shadcn/UI components
│   ├── forms/                    # Formularios
│   ├── layout/                   # Sidebar, header, etc
│   └── shared/                   # Componentes compartilhados
├── lib/                          # Utilitarios e configs
│   ├── supabase/                 # Cliente Supabase
│   │   ├── client.ts             # Cliente browser
│   │   ├── server.ts             # Cliente server
│   │   └── middleware.ts         # Auth middleware
│   ├── hooks/                    # React hooks customizados
│   ├── stores/                   # Zustand stores
│   └── validations/              # Schemas Zod
├── types/                        # Tipos TypeScript
│   └── database.ts               # Tipos gerados do Supabase
└── styles/
    └── globals.css               # Estilos globais + Tailwind
```

**3.3** Configurar variaveis de ambiente:
Criar arquivo `.env.local` na raiz do projeto com as credenciais da Etapa 1:
```
NEXT_PUBLIC_SUPABASE_URL=sua_url_aqui
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_anon_key_aqui
SUPABASE_SERVICE_ROLE_KEY=sua_service_role_key_aqui
```

**3.4** Rodar o projeto localmente:
```bash
npm run dev
```
Abrir http://localhost:3000 no navegador

### CHECKPOINT ETAPA 3:
- [ ] Node.js v18+ instalado
- [ ] Projeto Next.js rodando em http://localhost:3000
- [ ] Pagina inicial aparece no navegador
- [ ] VS Code aberto com os arquivos do projeto
- [ ] Arquivo `.env.local` criado com as credenciais

**Quando estiver OK, me avise: "Etapa 3 OK"**

---

## ETAPA 4: Auth + Login + Onboarding

**O que e:** Sistema de login, registro e primeiro acesso. Sem isso, ninguem entra no sistema.

### O que sera implementado:
- Pagina de **login** (email + senha)
- Pagina de **registro** de nova arena (trial de 14 dias)
- **Middleware de autenticacao** (protege rotas)
- **Redirect por role** (super_admin vai pro painel admin, arena_admin vai pro dashboard)
- **Criacao automatica** de arena + configuracoes padrao no registro

### Configuracoes no Supabase:
- Habilitar Auth por email/senha
- Configurar email templates (confirmacao, reset password)
- Configurar redirect URLs

### CHECKPOINT ETAPA 4:
- [ ] Consegue criar conta nova (registra no Supabase Auth + tabela `usuarios`)
- [ ] Login funciona com email/senha
- [ ] Logout funciona
- [ ] Rotas protegidas — sem login redireciona para /login
- [ ] Super admin acessando `/super-admin` consegue ver o painel
- [ ] Arena admin acessando `/dashboard` consegue ver o painel
- [ ] Nova arena criada com status `trial` e 14 dias de validade

**Quando estiver OK, me avise: "Etapa 4 OK"**

---

## ETAPA 5: Dashboard + Arenas + Quadras

**O que e:** O "coracao" do sistema — o painel principal, gestao de arenas e quadras.

### O que sera implementado:
- **Dashboard** com resumo (alunos, quadras, agendamentos hoje, receita do mes)
- **Super Admin Dashboard** com metricas SaaS (MRR, arenas ativas, churn)
- **CRUD Arenas** (criar, editar, ver detalhes, config visual)
- **CRUD Quadras** (criar, editar, bloqueios, manutencoes)
- **Switch de arena** para multi-arena (se proprietario tiver mais de uma)
- **Sidebar navigation** responsiva

### CHECKPOINT ETAPA 5:
- [ ] Dashboard mostra dados reais do banco
- [ ] Criar/editar/deletar quadra funciona
- [ ] Bloqueio de quadra funciona
- [ ] Config da arena (nome, logo, cores) funciona
- [ ] Super admin ve todas as arenas
- [ ] Arena admin so ve sua(s) arena(s) — RLS funcionando

**Quando estiver OK, me avise: "Etapa 5 OK"**

---

## ETAPA 6: Agendamentos + Calendario

**O que e:** O modulo que seus clientes mais vao usar — reservar quadras, ver calendario, fazer check-in.

### O que sera implementado:
- **Calendario visual** (semanal/diario) com FullCalendar
- **Criar agendamento** (selecionar quadra, horario, participantes)
- **Verificacao de conflito** (nao deixa agendar quadra ocupada)
- **Lista de espera** quando a quadra esta cheia
- **Check-in** por QR Code ou GPS
- **Agendamentos recorrentes** (toda segunda as 18h)
- **Cancelamento** com motivo

### CHECKPOINT ETAPA 6:
- [ ] Calendario mostra agendamentos do dia/semana
- [ ] Criar agendamento funciona (valida conflito)
- [ ] Cancelar agendamento funciona
- [ ] Lista de espera funciona
- [ ] Check-in funciona
- [ ] Agendamento recorrente funciona
- [ ] Aluno so ve SEUS agendamentos — RLS

**Quando estiver OK, me avise: "Etapa 6 OK"**

---

## ETAPA 7: Financeiro + Asaas

**O que e:** Onde o dinheiro entra — contratos, faturas, cobranca automatica via PIX/boleto/cartao.

### O que sera implementado:
- **CRUD Contratos** (mensalidade, desconto, vigencia)
- **Geracao automatica de faturas** mensais
- **Integracao Asaas** — criar cobranca, gerar QR PIX, boleto
- **Webhook Asaas** — receber notificacao de pagamento (Edge Function)
- **Dashboard financeiro** (receita, inadimplencia, fluxo de caixa)
- **Comissoes de professores** (calculo automatico)

### Configuracoes necessarias:
- Conta no Asaas (https://www.asaas.com)
- API Key do Asaas (modo sandbox primeiro!)
- Configurar webhook URL no Asaas

### CHECKPOINT ETAPA 7:
- [ ] Criar contrato gera fatura automaticamente
- [ ] Fatura gera cobranca no Asaas (sandbox)
- [ ] QR PIX e gerado e exibido
- [ ] Boleto e gerado com URL funcional
- [ ] Quando pagamento e confirmado no Asaas, fatura muda para "paga"
- [ ] Dashboard financeiro mostra dados corretos
- [ ] Comissao de professor e calculada

**Quando estiver OK, me avise: "Etapa 7 OK"**

---

## ETAPA 8: Aulas + Torneios

**O que e:** Modulos avancados — gestao de aulas com matricula/reposicao, e torneios com chaveamento.

### O que sera implementado:
- **CRUD Tipos de aula** (beach tennis adulto, kids, etc.)
- **Matriculas** de alunos em aulas
- **Controle de presenca** por aula
- **Sistema de reposicao** (faltou = pode repor)
- **Pacotes de aulas avulsas** (comprar 5, usar quando quiser)
- **CRUD Torneios** (criar, inscricoes, chaveamento automatico)
- **Bracket visual** para torneios

### CHECKPOINT ETAPA 8:
- [ ] Criar aula com professor, horario e alunos matriculados
- [ ] Lista de presenca funciona
- [ ] Reposicao de aula funciona
- [ ] Pacote de aulas: comprar e descontar creditos
- [ ] Criar torneio e gerar chaves automaticamente
- [ ] Inscricao em torneio funciona

**Quando estiver OK, me avise: "Etapa 8 OK"**

---

## ETAPA 9: WhatsApp + AI + Edge Functions

**O que e:** Automacoes inteligentes — mensagens automaticas, chatbot AI, lembretes.

### O que sera implementado:
- **14+ Edge Functions** (deploy no Supabase)
- **Integracao Evolution API** (envio de WhatsApp)
- **Chatbot AI** (Claude Haiku atende via WhatsApp)
- **Lembretes automaticos** (aula amanha, fatura vencendo)
- **Fila de mensagens** com rate limiting
- **Cron jobs** (tarefas agendadas: billing, reminders, overdue)
- **Insights AI** (Claude Sonnet analisa dados e sugere acoes)

### Configuracoes necessarias:
- **Evolution API** instalada (WhatsApp)
- **Anthropic API Key** (para Claude AI)
- **Supabase CLI** instalado para deploy de Edge Functions

### CHECKPOINT ETAPA 9:
- [ ] Edge Functions deployadas e respondendo
- [ ] Mensagem de confirmacao enviada via WhatsApp ao agendar
- [ ] Lembrete enviado 24h antes da aula
- [ ] Chatbot AI responde perguntas simples pelo WhatsApp
- [ ] Cron jobs rodando (verificar em `logs_execucao`)
- [ ] Fila de mensagens processando sem exceder rate limit

**Quando estiver OK, me avise: "Etapa 9 OK"**

---

## ETAPA 10: Deploy na Vercel + Go Live

**O que e:** Publicar o sistema para o mundo — URL real, HTTPS, dominio proprio.

### Passos:

**10.1** Criar conta na Vercel (https://vercel.com) — login com GitHub

**10.2** Conectar repositorio GitHub

**10.3** Configurar variaveis de ambiente na Vercel:
| Variavel | Valor |
|----------|-------|
| `NEXT_PUBLIC_SUPABASE_URL` | Sua URL do Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Sua anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Sua service role key |

**10.4** Deploy automatico (Vercel faz build e publica)

**10.5** Configurar dominio proprio (opcional):
- Comprar dominio (ex: `verana.com.br`)
- Configurar DNS na Vercel
- Configurar subdominos para arenas (ex: `arena.verana.com.br`)

**10.6** Migrar Asaas de **sandbox para producao**

**10.7** Verificar TUDO em producao:
- Login funciona
- Agendamento funciona
- Pagamento funciona (PIX real)
- WhatsApp funciona
- Chatbot AI funciona

### CHECKPOINT ETAPA 10:
- [ ] Site acessivel pela URL da Vercel (ex: verana.vercel.app)
- [ ] HTTPS funcionando (cadeado verde)
- [ ] Login funciona em producao
- [ ] Pagamento PIX real funciona
- [ ] WhatsApp envia mensagem real
- [ ] Dominio proprio configurado (se aplicavel)

**PARABENS! Seu SaaS esta no ar!**

---

## APOS O GO LIVE

### Primeira Semana:
- Monitorar erros (Sentry)
- Verificar logs de Edge Functions
- Acompanhar primeiros pagamentos
- Atender feedback dos primeiros clientes

### Primeiro Mes:
- Analisar metricas (PostHog)
- Ajustar precos se necessario
- Corrigir bugs reportados
- Comecar a trabalhar no app mobile (React Native)

### Futuro:
- App mobile (React Native + Expo)
- Marketplace de professores
- Ranking de jogadores
- Relatorios avancados com AI

---

## REGRAS DE OURO

1. **Nunca pule etapas** — cada uma depende da anterior
2. **Se deu erro, PARE** — me avise antes de tentar consertar sozinho
3. **Teste cada coisa** — nao confie que funcionou, verifique
4. **Guarde credenciais** — nunca coloque senhas no codigo
5. **Backup** — antes de mudancas grandes, salve o estado atual
6. **Uma coisa por vez** — foco na etapa atual, nao na proxima

---

*Plano criado em: 16/02/2026*
*Consultor: Arquiteto Fullstack Vibe Coding*
*Projeto: Verana Beach Tennis MicroSaaS*
