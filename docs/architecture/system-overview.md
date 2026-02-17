# Visao Geral do Sistema

[<- Voltar ao Indice](../README.md)

---

## Conceito

Sistema multi-tenant white-label para gestao completa de arenas de beach tennis. Cada arena opera como um tenant isolado, com customizacao visual propria e modulos ativaveis conforme o plano contratado.

## Principios Arquiteturais

| Principio | Descricao |
|-----------|-----------|
| **Multi-tenant** | Cada arena e um tenant isolado via `arena_id` + RLS |
| **White-label** | Customizacao visual (logo, cores, dominio) por arena |
| **Modular** | Funcionalidades ativadas/desativadas por plano |
| **Database First** | Schemas definidos antes do frontend |
| **Seguranca por padrao** | RLS em todas as 76 tabelas, auth obrigatorio |
| **Zero dependencia externa** | Automacoes via Supabase nativo (sem n8n) |
| **AI-first** | Chatbot, insights e analises integrados desde o inicio |

## Componentes do Sistema

```
┌────────────────────────────────────────────────────────┐
│                    CLIENTES                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  Web App      │  │  Mobile App  │  │  WhatsApp    │ │
│  │  (Next.js 14) │  │  (Expo)      │  │  (Evolution) │ │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘ │
└─────────┼──────────────────┼──────────────────┼────────┘
          │                  │                  │
┌─────────▼──────────────────▼──────────────────▼────────┐
│                 SUPABASE PLATFORM                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  Auth         │  │  Realtime    │  │  Edge Funcs  │ │
│  │  (JWT+OAuth)  │  │  (WebSocket) │  │  (14+ Deno)  │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  PostgreSQL   │  │  Storage     │  │  pg_cron     │ │
│  │  + RLS (76t)  │  │  (arquivos)  │  │  + pg_net    │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└────────────────────────────────────────────────────────┘
          │                  │                  │
┌─────────▼──────────────────▼──────────────────▼────────┐
│              INTEGRACOES EXTERNAS                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐ │
│  │  Asaas   │ │  Claude  │ │  Resend  │ │ Evolution │ │
│  │(pagamen.)│ │  (AI)    │ │ (email)  │ │ (WhatsApp)│ │
│  └──────────┘ └──────────┘ └──────────┘ └───────────┘ │
└────────────────────────────────────────────────────────┘
```

## Estrutura de Pastas - Frontend Web

```
src/
├── app/                          # Next.js App Router
│   ├── (auth)/                   # Rotas de autenticacao
│   ├── (dashboard)/              # Dashboard principal
│   │   ├── arenas/
│   │   ├── quadras/
│   │   ├── agendamentos/
│   │   ├── aulas/
│   │   ├── financeiro/
│   │   └── layout.tsx
│   ├── (super-admin)/           # Super Admin
│   └── api/                     # API routes (webhooks fallback)
├── components/                  # Componentes reutilizaveis
│   ├── ui/                     # Shadcn components
│   ├── forms/                  # Formularios especificos
│   ├── charts/                 # Graficos
│   └── modals/                 # Modais
├── lib/                        # Utilitarios
│   ├── supabase/              # Config Supabase
│   ├── validations/           # Schemas Zod
│   ├── services/              # Chamadas a Edge Functions
│   └── hooks/                 # Custom hooks
└── store/                     # Estado global (Zustand)
```

## Hierarquia de Usuarios e Permissoes

| Role | Escopo | Permissoes |
|------|--------|------------|
| **super_admin** | Plataforma | Controle total: arenas, metricas, MRR, anuncios, planos |
| **arena_admin** | Arena(s) | Gestao completa, multi-arena com switch de conta |
| **funcionario** | Arena | Operacoes do dia-a-dia conforme permissoes |
| **professor** | Arena | Gestao de aulas, alunos, agenda pessoal |
| **aluno** | Arena | App mobile, agendamentos, historico, pagamentos |

## Multi-tenancy

O isolamento de dados entre arenas e garantido por:

1. **Coluna `arena_id`** em todas as tabelas de dados
2. **Row Level Security (RLS)** no PostgreSQL - cada query e filtrada automaticamente
3. **Supabase Auth** - o token JWT contem o `user_id` que resolve para o `arena_id`
4. **Multi-arena** - tabela `usuarios_arenas` permite proprietarios com multiplas arenas

## Deploy

| Componente | Plataforma | Trigger |
|------------|------------|---------|
| Frontend Web | Vercel | Push to `main` |
| Mobile | EAS Build | Manual / CI |
| Database | Supabase | Migrations SQL |
| Edge Functions | Supabase | `npx supabase functions deploy` |
| Cron Jobs | Supabase pg_cron | Via SQL + Edge Functions |

---

**Proximos:** [Stack Tecnologica](./tech-stack.md) | [Schemas SQL](../database/schemas.md)
