# Verana Beach Tennis - MicroSaaS

**Sistema Multi-tenant White-label para Gestao Completa de Arenas de Beach Tennis**

| Item | Detalhe |
|------|---------|
| **Versao** | 1.1 |
| **Stack** | Next.js 14 + Supabase + React Native |
| **Tipo** | CRM/ERP Multi-tenant White-label |
| **Status** | Banco de dados pronto / Pre-implementacao frontend |

---

## Sobre o Projeto

Sistema SaaS modular para gestao de arenas de beach tennis, oferecendo diferentes planos de assinatura com modulos ativaveis conforme o nivel contratado. Cada arena opera como um tenant isolado com customizacao visual propria.

### Principais Capacidades

- **Multi-tenant**: Isolamento completo por arena com Row Level Security
- **White-label**: Customizacao visual (logo, cores, dominio) por arena
- **Modular**: Ativacao/desativacao de funcionalidades por plano
- **Escalavel**: Arquitetura preparada para crescimento organico
- **Responsivo**: Interface web + App mobile nativo

---

## Planos e Modulos

| Modulo | Basico (R$39,90) | Pro (R$89,90) | Premium (R$159,90) |
|--------|:-----------------:|:---------------:|:-------------------:|
| Dashboard | x | x | x |
| Gestao de Arenas | x | x | x |
| Gestao de Quadras | x | x | x |
| Gestao de Pessoas | x | x | x |
| Agendamentos | x | x | x |
| Gestao de Aulas | - | x | x |
| Gestao Financeira | basico | x | x |
| Torneios e Eventos | - | - | x |
| Relatorios Avancados | - | x | x |
| Automacoes | - | - | x |
| WhatsApp Integration | - | x | x |

---

## Stack Tecnologica

### Frontend Web
- **Framework:** Next.js 14 (App Router) + TypeScript
- **UI:** Tailwind CSS + Shadcn/UI
- **Estado:** Zustand + React Query
- **Formularios:** React Hook Form + Zod
- **Graficos:** Recharts + Chart.js
- **Calendario:** FullCalendar.js

### Mobile
- **Framework:** React Native + Expo
- **Navegacao:** React Navigation v6
- **UI:** Native Base + Custom Components

### Backend & Infraestrutura
- **Database:** Supabase (PostgreSQL + RLS)
- **Auth:** Supabase Auth
- **Storage:** Supabase Storage
- **APIs:** Supabase Edge Functions
- **Real-time:** Supabase Realtime
- **Deploy Web:** Vercel
- **Deploy Mobile:** EAS Build

### Integracoes Externas
- **WhatsApp:** Evolution API
- **Pagamentos:** Asaas
- **Automacoes:** n8n
- **Email:** Resend
- **SMS:** Twilio
- **Monitoramento:** Sentry + PostHog

---

## Documentacao

Toda a documentacao do projeto esta organizada na pasta [`docs/`](./docs/README.md):

| Categoria | Descricao | Link |
|-----------|-----------|------|
| **Arquitetura** | Visao geral do sistema e decisoes tecnicas | [`docs/architecture/`](./docs/architecture/) |
| **Banco de Dados** | Schemas SQL, RLS, triggers e seeds | [`docs/database/`](./docs/database/) |
| **Modulos** | Documentacao detalhada de cada modulo funcional | [`docs/modules/`](./docs/modules/) |
| **Interface** | Design system, wireframes e componentes | [`docs/ui/`](./docs/ui/) |
| **Integracoes** | WhatsApp, Asaas, n8n e webhooks | [`docs/integrations/`](./docs/integrations/) |
| **Guias** | Setup, implementacao e deploy | [`docs/guides/`](./docs/guides/) |

> **Documentos legados** estao arquivados em [`11-beach-tennis-microsass/`](./11-beach-tennis-microsass/) para referencia historica.

---

## Hierarquia de Usuarios

```
Super Admin (White-label Owner)
  └── Arena Admin (Dono da Arena)
        ├── Funcionarios (Staff)
        ├── Professores (Instrutores)
        └── Alunos/Clientes (Usuarios finais - App mobile)
```

---

## Roadmap

| Fase | Escopo | Status |
|------|--------|--------|
| **Fase 1 - MVP** | Auth, multi-tenancy, arenas, quadras, agendamentos | Documentado |
| **Fase 2 - Core** | Financeiro, aulas, WhatsApp, app mobile | Documentado |
| **Fase 3 - Advanced** | Torneios, relatorios avancados, automacoes, ranking | Documentado |
| **Fase 4 - Scale** | Performance, analytics, AI/ML, marketplace | Planejado |

---

## Estrutura do Repositorio

```
verana-beach-tennis/
├── README.md                    # Este arquivo
├── CLAUDE.md                    # Contexto para assistentes AI
├── docs/                        # Documentacao estruturada
│   ├── architecture/            # Arquitetura do sistema
│   ├── database/                # Schemas e seguranca
│   ├── modules/                 # Modulos funcionais
│   ├── ui/                      # Design e wireframes
│   ├── integrations/            # APIs externas
│   └── guides/                  # Guias de implementacao
├── supabase/
│   ├── migrations/              # 18 arquivos SQL (executar em ordem)
│   └── GUIA_EXECUCAO.md         # Guia passo-a-passo para executar o banco
└── 11-beach-tennis-microsass/   # Documentos legados (arquivo)
    ├── current/                 # Versao consolidada legada
    ├── docs-analysis/           # Documentos fonte originais
    ├── versions/                # Historico de versoes
    └── assets/                  # Recursos e imagens
```

---

*Projeto iniciado em: 28/09/2025*
*Framework de documentacao aplicado em: 14/02/2026*
