# CLAUDE.md - Contexto do Projeto Verana Beach Tennis

## O que e este projeto

Sistema MicroSaaS multi-tenant white-label para gestao de arenas de beach tennis.
Este repositorio contem a **documentacao completa** do sistema (especificacao, schemas, wireframes, prompts de implementacao). Nao contem codigo de implementacao.

## Stack Tecnologica

- **Frontend Web:** Next.js 14 (App Router) + TypeScript + Tailwind CSS + Shadcn/UI
- **Mobile:** React Native + Expo
- **Backend:** Supabase (PostgreSQL + RLS + Auth + Edge Functions + Realtime)
- **Deploy:** Vercel (web) + EAS Build (mobile)
- **Integracoes:** Evolution API (WhatsApp), Asaas (pagamentos), n8n (automacoes)

## Estrutura da Documentacao

```
docs/
├── architecture/          # Arquitetura do sistema e stack
├── database/              # Schemas SQL, RLS, triggers, seeds
├── modules/               # 8 modulos funcionais (00 a 07)
├── ui/                    # Design system e wireframes
├── integrations/          # WhatsApp, Asaas, n8n
└── guides/                # Setup, implementacao, deploy
```

Documentos legados em `11-beach-tennis-microsass/` (arquivo historico).

## Modulos do Sistema

0. **Super Admin** - Gestao white-label, planos, arenas
1. **Arenas** - Cadastro, config, customizacao visual
2. **Quadras** - Cadastro, bloqueios, manutencoes
3. **Pessoas** - Usuarios, professores, funcionarios
4. **Agendamentos** - Reservas, check-in (QR/GPS), recorrencia
5. **Aulas** - Tipos, matriculas, pacotes, reposicoes
6. **Financeiro** - Contratos, faturas, Asaas, comissoes
7. **Torneios** - Torneios, eventos, inscricoes, chaveamento

## Hierarquia de Usuarios

- super_admin > arena_admin > funcionario/professor > aluno

## Padroes de Banco de Dados

- Multi-tenant isolado por `arena_id`
- Row Level Security (RLS) em todas as tabelas principais
- ENUMs customizados para padronizacao
- Triggers de auditoria e updated_at automatico
- Indices otimizados para consultas frequentes

## Convencoes

- Documentacao em Portugues (Brasil)
- Nomes de tabelas/colunas em portugues snake_case
- Componentes React em PascalCase
- Rotas Next.js usando App Router com route groups: (auth), (dashboard), (super-admin)
- Validacao de formularios com Zod schemas
- Estado global com Zustand, dados remotos com React Query
