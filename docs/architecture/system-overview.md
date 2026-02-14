# Visao Geral do Sistema

[<- Voltar ao Indice](../README.md)

---

## Conceito

Sistema multi-tenant white-label para gestao completa de arenas de beach tennis. Cada arena opera como um tenant isolado, com customizacao visual propria e modulos ativaveis conforme o plano contratado.

## Principios Arquiteturais

| Principio | Descricao |
|-----------|-----------|
| **Multi-tenant** | Cada arena e um tenant isolado via `arena_id` + RLS |
| **White-label** | Customizacao visual (logo, cores) por arena |
| **Modular** | Funcionalidades ativadas/desativadas por plano |
| **Database First** | Schemas definidos antes do frontend |
| **Seguranca por padrao** | RLS em todas as tabelas, auth obrigatorio |

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
│  └──────────────┘  └──────────────┘  └──────────────┘ │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  PostgreSQL   │  │  Storage     │  │  REST API    │ │
│  │  + RLS        │  │  (arquivos)  │  │  (auto)      │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└────────────────────────────────────────────────────────┘
          │                  │                  │
┌─────────▼──────────────────▼──────────────────▼────────┐
│              INTEGRACOES EXTERNAS                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐ │
│  │  Asaas   │ │  n8n     │ │  Resend  │ │  Twilio   │ │
│  │(pagamen.)│ │(automat.)│ │ (email)  │ │  (SMS)    │ │
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
│   └── api/                     # API routes + webhooks
├── components/                  # Componentes reutilizaveis
│   ├── ui/                     # Shadcn components
│   ├── forms/                  # Formularios especificos
│   ├── charts/                 # Graficos
│   └── modals/                 # Modais
├── lib/                        # Utilitarios
│   ├── supabase/              # Config Supabase
│   ├── validations/           # Schemas Zod
│   ├── services/              # Servicos externos
│   └── hooks/                 # Custom hooks
└── store/                     # Estado global (Zustand)
```

## Hierarquia de Usuarios e Permissoes

| Role | Escopo | Permissoes |
|------|--------|------------|
| **super_admin** | Plataforma | Controle total de todas as arenas, planos, faturamento |
| **arena_admin** | Arena | Gestao completa da arena, usuarios, configuracoes |
| **funcionario** | Arena | Operacoes do dia-a-dia conforme permissoes |
| **professor** | Arena | Gestao de aulas, alunos, agenda pessoal |
| **aluno** | Arena | App mobile, agendamentos, historico, pagamentos |

### Sistema de Permissoes

```typescript
export enum Permission {
  ARENA_CREATE = 'arena:create',
  ARENA_READ = 'arena:read',
  ARENA_UPDATE = 'arena:update',
  QUADRA_MANAGE = 'quadra:manage',
  AGENDAMENTO_MANAGE = 'agendamento:manage',
  FINANCEIRO_READ = 'financeiro:read',
  RELATORIOS_ACCESS = 'relatorios:access',
}
```

## Multi-tenancy

O isolamento de dados entre arenas e garantido por:

1. **Coluna `arena_id`** em todas as tabelas de dados
2. **Row Level Security (RLS)** no PostgreSQL - cada query e filtrada automaticamente
3. **Supabase Auth** - o token JWT contem o `user_id` que resolve para o `arena_id`

```sql
-- Exemplo: usuario so ve dados da propria arena
CREATE POLICY "tenant_isolation" ON usuarios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios
    WHERE auth_id = auth.uid()
  )
);
```

## Deploy

| Componente | Plataforma | Trigger |
|------------|------------|---------|
| Frontend Web | Vercel | Push to `main` |
| Mobile | EAS Build | Manual / CI |
| Database | Supabase | Migrations |
| Edge Functions | Supabase | Deploy CLI |

---

**Proximos:** [Stack Tecnologica](./tech-stack.md) | [Schemas SQL](../database/schemas.md)
