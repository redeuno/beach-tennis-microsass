# Getting Started

[<- Voltar ao Indice](../README.md) | [Sequencia de Implementacao](./implementation-sequence.md)

---

## Pre-requisitos

- Node.js 18+
- npm ou yarn
- Conta no Supabase (plano Free ou superior)
- Conta no Vercel (para deploy)

## Setup do Projeto

### 1. Criar projeto Next.js

```bash
npx create-next-app@latest verana-beach-tennis --typescript --tailwind --eslint --app --src-dir
cd verana-beach-tennis
```

### 2. Instalar dependencias

```bash
# UI
npx shadcn-ui@latest init
npx shadcn-ui@latest add button card input select badge avatar dialog tabs table

# Estado e dados
npm install zustand @tanstack/react-query

# Formularios
npm install react-hook-form @hookform/resolvers zod

# Supabase
npm install @supabase/supabase-js @supabase/ssr

# Graficos e calendario
npm install recharts @fullcalendar/react @fullcalendar/daygrid @fullcalendar/timegrid

# Icones
npm install lucide-react

# Notificacoes
npm install react-hot-toast
```

### 3. Configurar Supabase

1. Criar projeto no Supabase Dashboard
2. Copiar URL e Anon Key
3. Criar arquivo `.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### 4. Executar schemas

Executar os schemas SQL no SQL Editor do Supabase na seguinte ordem:
1. Extensoes e configuracoes iniciais
2. ENUMs (tipos personalizados)
3. Tabelas de plataforma (planos, modulos)
4. Tabelas principais (arenas, usuarios, quadras)
5. Tabelas de negocio (agendamentos, aulas, financeiro, torneios)
6. Tabelas de configuracao (config, politicas, auditoria)
7. Politicas RLS
8. Triggers e funcoes
9. Indices
10. Seeds

> Todos os schemas estao em [`docs/database/schemas.md`](../database/schemas.md)

### 5. Validar RLS

Apos criar as tabelas, verificar que RLS esta ativo:
- Supabase Dashboard > Authentication > Policies
- Testar isolamento de tenant com usuarios de arenas diferentes

## Estrutura de Pastas

Criar a estrutura conforme descrito em [`docs/architecture/system-overview.md`](../architecture/system-overview.md).

## Proximo Passo

Seguir a [Sequencia de Implementacao](./implementation-sequence.md) para construir o sistema modulo por modulo.
