# VERANA BEACH TENNIS - PROMPTS COMPLETOS PARA LOVABLE
## Sequência Lógica de Implementação com Schemas Integrados

**Versão: 1.0**  
**Data: 28/09/2025**  
**Base:** Consolidação dos prompts + schemas + estrutura completa  
**Objetivo:** Implementação sequencial no Lovable com máxima eficiência

---

## VISÃO GERAL DA IMPLEMENTAÇÃO

### **Estratégia de Desenvolvimento:**
1. **Database First**: Criar schemas antes do frontend
2. **Modular**: Implementar módulo por módulo
3. **Incremental**: Cada prompt adiciona funcionalidades
4. **Testável**: Validar cada etapa antes de prosseguir

### **Sequência Otimizada:**
1. **Setup + Database** - Estrutura base e schemas
2. **Auth + Permissions** - Sistema de autenticação
3. **Core Modules** - Módulos essenciais (arenas, quadras, usuários)
4. **Business Logic** - Agendamentos e aulas
5. **Financial** - Sistema financeiro e Asaas
6. **Advanced** - Torneios, relatórios, comunicação

---

## PROMPT 0: SETUP INICIAL E DATABASE SCHEMAS

```
Crie um projeto Next.js 14 completo para gestão de arenas de Beach Tennis com configuração inicial do Supabase.

### CONFIGURAÇÃO TÉCNICA:
- Next.js 14 com App Router e TypeScript
- Supabase para backend completo
- Tailwind CSS + Shadcn/UI
- Zustand + React Query
- Sistema multi-tenant com RLS

### PRIMEIRO PASSO - CONFIGURAR SUPABASE:
1. Crie um novo projeto no Supabase
2. Configure as variáveis de ambiente:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### SEGUNDO PASSO - EXECUTAR SCHEMAS SQL:
Execute os seguintes comandos SQL no SQL Editor do Supabase na ordem exata:

#### 1. EXTENSÕES E CONFIGURAÇÕES:
```sql
-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Configurar timezone padrão
SET timezone = 'America/Sao_Paulo';

-- Habilitar RLS globalmente
ALTER DATABASE postgres SET row_security = on;
```

#### 2. TIPOS PERSONALIZADOS (ENUMS):
```sql
-- Tipos de usuário
CREATE TYPE user_role AS ENUM (
  'super_admin',
  'arena_admin', 
  'funcionario',
  'professor',
  'aluno'
);

-- Status gerais
CREATE TYPE status_geral AS ENUM ('ativo', 'inativo', 'suspenso', 'bloqueado');

-- Tipos de esporte
CREATE TYPE tipo_esporte AS ENUM ('beach_tennis', 'padel', 'tenis', 'futevolei');

-- Status de agendamento
CREATE TYPE status_agendamento AS ENUM ('confirmado', 'pendente', 'cancelado', 'realizado', 'no_show');

-- Status de pagamento
CREATE TYPE status_pagamento AS ENUM ('pendente', 'pago', 'parcial', 'cancelado', 'vencido', 'estornado');

-- Formas de pagamento
CREATE TYPE forma_pagamento AS ENUM ('pix', 'cartao_credito', 'cartao_debito', 'dinheiro', 'boleto', 'credito');

-- Tipos de agendamento
CREATE TYPE tipo_agendamento AS ENUM ('avulso', 'aula', 'torneio', 'evento');

-- Tipos de check-in
CREATE TYPE tipo_checkin AS ENUM ('qrcode', 'geolocalizacao', 'manual', 'biometria');

-- Níveis de jogo
CREATE TYPE nivel_jogo AS ENUM ('iniciante', 'intermediario', 'avancado', 'profissional');

-- Tipos de plano
CREATE TYPE tipo_plano AS ENUM ('mensal', 'trimestral', 'semestral', 'anual');

-- Status de contrato
CREATE TYPE status_contrato AS ENUM ('ativo', 'suspenso', 'cancelado', 'inadimplente');

-- Status de fatura
CREATE TYPE status_fatura AS ENUM ('pendente', 'paga', 'vencida', 'cancelada');

-- Tipos de módulo
CREATE TYPE tipo_modulo AS ENUM ('core', 'financeiro', 'comunicacao', 'relatorios', 'premium');

-- Níveis de acesso a relatórios
CREATE TYPE nivel_acesso_relatorio AS ENUM ('publico', 'professor', 'funcionario', 'admin', 'super_admin');
```

Após executar estes comandos, confirme que foram criados com sucesso antes de prosseguir para o próximo prompt.
```---


## PROMPT 1: TABELAS PRINCIPAIS DO SISTEMA

```
Continue a configuração do banco de dados criando as tabelas principais do sistema.

### TERCEIRO PASSO - TABELAS DE CONTROLE:

#### 1. PLANOS DO SISTEMA (Super Admin):
```sql
CREATE TABLE planos_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL,
  valor_mensal DECIMAL(8,2) NOT NULL,
  max_quadras INTEGER NOT NULL DEFAULT 10,
  max_usuarios INTEGER NOT NULL DEFAULT 100,
  modulos_inclusos JSONB NOT NULL DEFAULT '[]',
  recursos_extras JSONB DEFAULT '{}',
  descricao TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. MÓDULOS DO SISTEMA:
```sql
CREATE TABLE modulos_sistema (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nome VARCHAR(100) NOT NULL UNIQUE,
  codigo VARCHAR(50) NOT NULL UNIQUE,
  tipo tipo_modulo NOT NULL,
  descricao TEXT NOT NULL,
  icone VARCHAR(100),
  ordem INTEGER NOT NULL DEFAULT 0,
  status status_geral NOT NULL DEFAULT 'ativo',
  dependencias JSONB DEFAULT '[]',
  configuracoes_padrao JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 3. ARENAS:
```sql
CREATE TABLE arenas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL UNIQUE,
  nome VARCHAR(100) NOT NULL,
  razao_social VARCHAR(200) NOT NULL,
  cnpj VARCHAR(18) NOT NULL UNIQUE,
  telefone VARCHAR(15) NOT NULL,
  whatsapp VARCHAR(15) NOT NULL,
  email VARCHAR(100) NOT NULL,
  endereco_completo JSONB NOT NULL,
  coordenadas POINT,
  logo_url TEXT,
  cores_tema JSONB DEFAULT '{"primary": "#0066CC", "secondary": "#FF6B35"}',
  horario_funcionamento JSONB NOT NULL,
  configuracoes JSONB DEFAULT '{}',
  status status_geral NOT NULL DEFAULT 'ativo',
  plano_sistema_id UUID REFERENCES planos_sistema(id),
  data_vencimento DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 4. CONTROLE DE MÓDULOS POR ARENA:
```sql
CREATE TABLE arena_modulos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  modulo_id UUID REFERENCES modulos_sistema(id) ON DELETE CASCADE,
  ativo BOOLEAN NOT NULL DEFAULT true,
  configuracoes JSONB DEFAULT '{}',
  data_ativacao TIMESTAMPTZ DEFAULT NOW(),
  data_desativacao TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, modulo_id)
);
```

#### 5. USUÁRIOS:
```sql
CREATE TABLE usuarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  auth_id UUID UNIQUE, -- ID do Supabase Auth
  tipo_usuario user_role NOT NULL,
  nome_completo VARCHAR(150) NOT NULL,
  email VARCHAR(100) NOT NULL,
  telefone VARCHAR(15) NOT NULL,
  whatsapp VARCHAR(15),
  cpf VARCHAR(14) NOT NULL,
  data_nascimento DATE NOT NULL,
  genero VARCHAR(20),
  endereco JSONB,
  nivel_jogo nivel_jogo,
  dominancia VARCHAR(20),
  posicao_preferida VARCHAR(20),
  observacoes_medicas TEXT,
  contato_emergencia JSONB,
  foto_url TEXT,
  status status_geral NOT NULL DEFAULT 'ativo',
  data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE,
  ultimo_acesso TIMESTAMPTZ,
  aceite_termos BOOLEAN NOT NULL DEFAULT false,
  aceite_marketing BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, email),
  UNIQUE(arena_id, cpf)
);
```

### QUARTO PASSO - INSERIR DADOS INICIAIS:
```sql
-- Inserir módulos do sistema
INSERT INTO modulos_sistema (nome, codigo, tipo, descricao, ordem) VALUES
('Dashboard', 'dashboard', 'core', 'Painel principal com métricas e visão geral', 1),
('Gestão de Arenas', 'arenas', 'core', 'Configuração e gestão da arena', 2),
('Gestão de Quadras', 'quadras', 'core', 'Cadastro e controle de quadras', 3),
('Gestão de Pessoas', 'pessoas', 'core', 'Cadastro de usuários, professores e alunos', 4),
('Agendamentos', 'agendamentos', 'core', 'Sistema de reservas e agendamentos', 5),
('Gestão de Aulas', 'aulas', 'premium', 'Sistema completo de aulas e matrículas', 6),
('Gestão Financeira', 'financeiro', 'financeiro', 'Controle financeiro e faturamento', 7),
('Torneios e Eventos', 'torneios', 'premium', 'Organização de torneios e eventos', 8),
('Relatórios', 'relatorios', 'relatorios', 'Relatórios e analytics', 9),
('Comunicação', 'comunicacao', 'comunicacao', 'WhatsApp, Email e SMS', 10);

-- Inserir planos do sistema
INSERT INTO planos_sistema (nome, valor_mensal, max_quadras, max_usuarios, modulos_inclusos) VALUES
('Básico', 89.90, 5, 50, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos"]'),
('Pro', 189.90, 15, 200, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "comunicacao", "relatorios"]'),
('Premium', 389.90, 50, 1000, '["dashboard", "arenas", "quadras", "pessoas", "agendamentos", "aulas", "financeiro", "torneios", "comunicacao", "relatorios"]');
```

Confirme que todas as tabelas foram criadas com sucesso antes de prosseguir.
```

---

## PROMPT 2: ESTRUTURA FRONTEND E AUTENTICAÇÃO

```
Agora crie a estrutura frontend do projeto Next.js 14 com sistema de autenticação.

### CONFIGURAÇÃO DO PROJETO:

#### 1. ESTRUTURA DE PASTAS:
```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── register/
│   │   │   └── page.tsx
│   │   └── layout.tsx
│   ├── (super-admin)/
│   │   ├── arenas/
│   │   ├── modulos/
│   │   ├── relatorios/
│   │   └── layout.tsx
│   ├── (dashboard)/
│   │   ├── page.tsx
│   │   ├── quadras/
│   │   ├── agendamentos/
│   │   ├── pessoas/
│   │   ├── aulas/
│   │   ├── financeiro/
│   │   ├── torneios/
│   │   ├── comunicacao/
│   │   ├── relatorios/
│   │   ├── configuracoes/
│   │   └── layout.tsx
│   ├── api/
│   │   └── auth/
│   ├── globals.css
│   └── layout.tsx
├── components/
│   ├── ui/ (shadcn components)
│   ├── auth/
│   ├── layout/
│   ├── forms/
│   └── common/
├── lib/
│   ├── supabase/
│   ├── auth/
│   ├── validations/
│   └── utils/
├── stores/
├── types/
└── hooks/
```

#### 2. CONFIGURAÇÃO SUPABASE:
```typescript
// lib/supabase/client.ts
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'
import { Database } from '@/types/database'

export const supabase = createClientComponentClient<Database>()

// lib/supabase/server.ts
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { Database } from '@/types/database'

export const createServerSupabaseClient = () => {
  return createServerComponentClient<Database>({ cookies })
}
```

#### 3. TIPOS TYPESCRIPT:
```typescript
// types/auth.ts
export type UserRole = 'super_admin' | 'arena_admin' | 'funcionario' | 'professor' | 'aluno'

export interface User {
  id: string
  arena_id?: string
  auth_id: string
  tipo_usuario: UserRole
  nome_completo: string
  email: string
  telefone: string
  status: 'ativo' | 'inativo' | 'suspenso'
}

// types/database.ts
export interface Database {
  public: {
    Tables: {
      usuarios: {
        Row: User
        Insert: Omit<User, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<User>
      }
      arenas: {
        Row: Arena
        Insert: Omit<Arena, 'id' | 'created_at' | 'updated_at'>
        Update: Partial<Arena>
      }
      // ... outras tabelas
    }
  }
}
```

#### 4. SISTEMA DE AUTENTICAÇÃO:
```typescript
// hooks/useAuth.ts
import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase/client'
import { User } from '@/types/auth'

export const useAuth = () => {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Verificar sessão atual
    const getSession = async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (session?.user) {
        // Buscar dados completos do usuário
        const { data: userData } = await supabase
          .from('usuarios')
          .select('*')
          .eq('auth_id', session.user.id)
          .single()
        
        setUser(userData)
      }
      setLoading(false)
    }

    getSession()

    // Escutar mudanças de auth
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (session?.user) {
          const { data: userData } = await supabase
            .from('usuarios')
            .select('*')
            .eq('auth_id', session.user.id)
            .single()
          
          setUser(userData)
        } else {
          setUser(null)
        }
        setLoading(false)
      }
    )

    return () => subscription.unsubscribe()
  }, [])

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    return { error }
  }

  const signOut = async () => {
    const { error } = await supabase.auth.signOut()
    return { error }
  }

  return {
    user,
    loading,
    signIn,
    signOut
  }
}
```

#### 5. COMPONENTES DE LAYOUT:
```tsx
// components/layout/DashboardLayout.tsx
'use client'

import { useAuth } from '@/hooks/useAuth'
import { Sidebar } from './Sidebar'
import { Header } from './Header'
import { LoadingSpinner } from '@/components/ui/loading-spinner'

export const DashboardLayout = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth()

  if (loading) {
    return <LoadingSpinner />
  }

  if (!user) {
    redirect('/login')
  }

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar user={user} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header user={user} />
        <main className="flex-1 overflow-auto p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
```

Implemente a estrutura base com autenticação funcional e layout responsivo.
```

---

## PROMPT 3: SISTEMA DE PERMISSÕES E RLS

```
Configure o sistema completo de permissões e Row Level Security (RLS) no Supabase.

### CONFIGURAÇÃO RLS NO SUPABASE:

#### 1. HABILITAR RLS NAS TABELAS:
```sql
-- Habilitar RLS em todas as tabelas principais
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE arena_modulos ENABLE ROW LEVEL SECURITY;
ALTER TABLE modulos_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE planos_sistema ENABLE ROW LEVEL SECURITY;
```

#### 2. POLÍTICAS PARA SUPER ADMIN:
```sql
-- Super Admin tem acesso total
CREATE POLICY "super_admin_full_access" ON arenas
FOR ALL USING (
  auth.uid() IN (
    SELECT auth_id FROM usuarios 
    WHERE tipo_usuario = 'super_admin'
  )
);

CREATE POLICY "super_admin_usuarios_access" ON usuarios
FOR ALL USING (
  auth.uid() IN (
    SELECT auth_id FROM usuarios 
    WHERE tipo_usuario = 'super_admin'
  )
);

CREATE POLICY "super_admin_modulos_access" ON modulos_sistema
FOR ALL USING (
  auth.uid() IN (
    SELECT auth_id FROM usuarios 
    WHERE tipo_usuario = 'super_admin'
  )
);
```

#### 3. POLÍTICAS DE ISOLAMENTO POR ARENA:
```sql
-- Usuários só veem dados da própria arena
CREATE POLICY "tenant_isolation_usuarios" ON usuarios
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "tenant_isolation_arenas" ON arenas
FOR ALL USING (
  id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "tenant_isolation_arena_modulos" ON arena_modulos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);
```

### SISTEMA DE PERMISSÕES NO FRONTEND:

#### 1. HOOK DE PERMISSÕES:
```typescript
// hooks/usePermissions.ts
import { useAuth } from './useAuth'

export enum Permission {
  // Arenas
  ARENA_CREATE = 'arena:create',
  ARENA_READ = 'arena:read',
  ARENA_UPDATE = 'arena:update',
  ARENA_DELETE = 'arena:delete',
  
  // Usuários
  USUARIO_CREATE = 'usuario:create',
  USUARIO_READ = 'usuario:read',
  USUARIO_UPDATE = 'usuario:update',
  USUARIO_DELETE = 'usuario:delete',
  
  // Módulos
  MODULO_MANAGE = 'modulo:manage',
  MODULO_CONFIG = 'modulo:config',
  
  // Relatórios
  RELATORIO_VIEW = 'relatorio:view',
  RELATORIO_CONFIG = 'relatorio:config'
}

const rolePermissions: Record<string, Permission[]> = {
  super_admin: Object.values(Permission),
  arena_admin: [
    Permission.ARENA_READ,
    Permission.ARENA_UPDATE,
    Permission.USUARIO_CREATE,
    Permission.USUARIO_READ,
    Permission.USUARIO_UPDATE,
    Permission.RELATORIO_VIEW,
    Permission.RELATORIO_CONFIG
  ],
  funcionario: [
    Permission.USUARIO_READ,
    Permission.RELATORIO_VIEW
  ],
  professor: [
    Permission.USUARIO_READ,
    Permission.RELATORIO_VIEW
  ],
  aluno: [
    Permission.RELATORIO_VIEW
  ]
}

export const usePermissions = () => {
  const { user } = useAuth()

  const hasPermission = (permission: Permission): boolean => {
    if (!user) return false
    const userPermissions = rolePermissions[user.tipo_usuario] || []
    return userPermissions.includes(permission)
  }

  const hasAnyPermission = (permissions: Permission[]): boolean => {
    return permissions.some(permission => hasPermission(permission))
  }

  const hasAllPermissions = (permissions: Permission[]): boolean => {
    return permissions.every(permission => hasPermission(permission))
  }

  return {
    hasPermission,
    hasAnyPermission,
    hasAllPermissions,
    userRole: user?.tipo_usuario
  }
}
```

#### 2. COMPONENTE DE PROTEÇÃO:
```tsx
// components/auth/PermissionGate.tsx
import { Permission, usePermissions } from '@/hooks/usePermissions'

interface PermissionGateProps {
  permission: Permission | Permission[]
  children: React.ReactNode
  fallback?: React.ReactNode
  requireAll?: boolean
}

export const PermissionGate = ({ 
  permission, 
  children, 
  fallback = null,
  requireAll = false 
}: PermissionGateProps) => {
  const { hasPermission, hasAnyPermission, hasAllPermissions } = usePermissions()

  const hasAccess = Array.isArray(permission)
    ? requireAll 
      ? hasAllPermissions(permission)
      : hasAnyPermission(permission)
    : hasPermission(permission)

  return hasAccess ? <>{children}</> : <>{fallback}</>
}
```

#### 3. MIDDLEWARE DE PROTEÇÃO:
```typescript
// middleware.ts
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs'
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export async function middleware(req: NextRequest) {
  const res = NextResponse.next()
  const supabase = createMiddlewareClient({ req, res })

  const {
    data: { session },
  } = await supabase.auth.getSession()

  // Rotas protegidas
  const protectedRoutes = ['/dashboard', '/super-admin']
  const isProtectedRoute = protectedRoutes.some(route => 
    req.nextUrl.pathname.startsWith(route)
  )

  if (isProtectedRoute && !session) {
    return NextResponse.redirect(new URL('/login', req.url))
  }

  // Verificar permissões específicas para super-admin
  if (req.nextUrl.pathname.startsWith('/super-admin')) {
    if (session) {
      const { data: user } = await supabase
        .from('usuarios')
        .select('tipo_usuario')
        .eq('auth_id', session.user.id)
        .single()

      if (user?.tipo_usuario !== 'super_admin') {
        return NextResponse.redirect(new URL('/dashboard', req.url))
      }
    }
  }

  return res
}

export const config = {
  matcher: ['/((?!api|_next/static|_next/image|favicon.ico).*)'],
}
```

Implemente o sistema de permissões completo com RLS funcionando corretamente.
```---

##
 PROMPT 4: GESTÃO DE QUADRAS E INFRAESTRUTURA

```
Crie o sistema completo de gestão de quadras com todas as funcionalidades necessárias.

### PRIMEIRO PASSO - CRIAR TABELAS DE QUADRAS:

#### 1. TABELA DE QUADRAS:
```sql
CREATE TABLE quadras (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(50) NOT NULL,
  numero INTEGER NOT NULL,
  tipo_esporte tipo_esporte NOT NULL,
  tipo_piso VARCHAR(20) NOT NULL,
  largura DECIMAL(5,2),
  comprimento DECIMAL(5,2),
  tem_cobertura BOOLEAN NOT NULL DEFAULT false,
  tem_iluminacao BOOLEAN NOT NULL DEFAULT false,
  capacidade_maxima INTEGER NOT NULL,
  valor_hora_pico DECIMAL(8,2) NOT NULL,
  valor_hora_normal DECIMAL(8,2) NOT NULL,
  horario_abertura TIME NOT NULL DEFAULT '06:00',
  horario_fechamento TIME NOT NULL DEFAULT '23:00',
  dias_funcionamento JSONB NOT NULL DEFAULT '["segunda", "terca", "quarta", "quinta", "sexta", "sabado", "domingo"]',
  horarios_pico JSONB NOT NULL DEFAULT '{}',
  equipamentos_inclusos JSONB DEFAULT '[]',
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  ultima_manutencao DATE,
  proxima_manutencao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero)
);
```

#### 2. TABELA DE BLOQUEIOS:
```sql
CREATE TABLE quadras_bloqueios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_bloqueio VARCHAR(20) NOT NULL,
  data_inicio TIMESTAMPTZ NOT NULL,
  data_fim TIMESTAMPTZ NOT NULL,
  motivo VARCHAR(200) NOT NULL,
  responsavel_id UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 3. TABELA DE MANUTENÇÕES:
```sql
CREATE TABLE manutencoes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  tipo_manutencao VARCHAR(20) NOT NULL,
  data_manutencao DATE NOT NULL,
  descricao TEXT NOT NULL,
  fornecedor VARCHAR(100),
  valor_gasto DECIMAL(8,2),
  tempo_parada INTEGER,
  responsavel_id UUID REFERENCES usuarios(id),
  proximo_agendamento DATE,
  anexos JSONB DEFAULT '[]',
  status VARCHAR(20) NOT NULL DEFAULT 'concluida',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### SEGUNDO PASSO - COMPONENTES FRONTEND:

#### 1. LISTA DE QUADRAS:
```tsx
// app/(dashboard)/quadras/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Plus, Edit, Calendar, Wrench } from 'lucide-react'
import { QuadraForm } from '@/components/quadras/QuadraForm'
import { BloqueioModal } from '@/components/quadras/BloqueioModal'

interface Quadra {
  id: string
  nome: string
  numero: number
  tipo_esporte: string
  capacidade_maxima: number
  valor_hora_normal: number
  valor_hora_pico: number
  status: string
  tem_cobertura: boolean
  tem_iluminacao: boolean
}

export default function QuadrasPage() {
  const [quadras, setQuadras] = useState<Quadra[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [selectedQuadra, setSelectedQuadra] = useState<string | null>(null)

  useEffect(() => {
    fetchQuadras()
  }, [])

  const fetchQuadras = async () => {
    try {
      const { data, error } = await supabase
        .from('quadras')
        .select('*')
        .order('numero')

      if (error) throw error
      setQuadras(data || [])
    } catch (error) {
      console.error('Erro ao buscar quadras:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'ativo': return 'bg-green-100 text-green-800'
      case 'manutencao': return 'bg-yellow-100 text-yellow-800'
      case 'inativo': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  if (loading) {
    return <div className="flex justify-center items-center h-64">Carregando...</div>
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Quadras</h1>
          <p className="text-gray-600">Gerencie as quadras da sua arena</p>
        </div>
        <Button onClick={() => setShowForm(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Nova Quadra
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {quadras.map((quadra) => (
          <Card key={quadra.id} className="hover:shadow-lg transition-shadow">
            <CardHeader className="pb-3">
              <div className="flex justify-between items-start">
                <div>
                  <CardTitle className="text-lg">{quadra.nome}</CardTitle>
                  <p className="text-sm text-gray-600">Quadra {quadra.numero}</p>
                </div>
                <Badge className={getStatusColor(quadra.status)}>
                  {quadra.status}
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <p className="font-medium">Modalidade</p>
                  <p className="text-gray-600 capitalize">{quadra.tipo_esporte.replace('_', ' ')}</p>
                </div>
                <div>
                  <p className="font-medium">Capacidade</p>
                  <p className="text-gray-600">{quadra.capacidade_maxima} pessoas</p>
                </div>
                <div>
                  <p className="font-medium">Valor/hora</p>
                  <p className="text-gray-600">R$ {quadra.valor_hora_normal}</p>
                </div>
                <div>
                  <p className="font-medium">Pico</p>
                  <p className="text-gray-600">R$ {quadra.valor_hora_pico}</p>
                </div>
              </div>

              <div className="flex gap-2 text-xs">
                {quadra.tem_cobertura && (
                  <Badge variant="outline">Coberta</Badge>
                )}
                {quadra.tem_iluminacao && (
                  <Badge variant="outline">Iluminada</Badge>
                )}
              </div>

              <div className="flex gap-2 pt-2">
                <Button 
                  size="sm" 
                  variant="outline"
                  onClick={() => setSelectedQuadra(quadra.id)}
                >
                  <Edit className="w-3 h-3 mr-1" />
                  Editar
                </Button>
                <Button size="sm" variant="outline">
                  <Calendar className="w-3 h-3 mr-1" />
                  Agenda
                </Button>
                <Button size="sm" variant="outline">
                  <Wrench className="w-3 h-3 mr-1" />
                  Manutenção
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {showForm && (
        <QuadraForm
          onClose={() => setShowForm(false)}
          onSuccess={() => {
            setShowForm(false)
            fetchQuadras()
          }}
        />
      )}
    </div>
  )
}
```

#### 2. FORMULÁRIO DE QUADRA:
```tsx
// components/quadras/QuadraForm.tsx
'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Checkbox } from '@/components/ui/checkbox'
import { Textarea } from '@/components/ui/textarea'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { toast } from 'sonner'

const quadraSchema = z.object({
  nome: z.string().min(1, 'Nome é obrigatório'),
  numero: z.number().min(1, 'Número deve ser maior que 0'),
  tipo_esporte: z.enum(['beach_tennis', 'padel', 'tenis', 'futevolei']),
  tipo_piso: z.string().min(1, 'Tipo de piso é obrigatório'),
  largura: z.number().optional(),
  comprimento: z.number().optional(),
  capacidade_maxima: z.number().min(1, 'Capacidade deve ser maior que 0'),
  valor_hora_normal: z.number().min(0, 'Valor deve ser positivo'),
  valor_hora_pico: z.number().min(0, 'Valor deve ser positivo'),
  tem_cobertura: z.boolean(),
  tem_iluminacao: z.boolean(),
  observacoes: z.string().optional()
})

type QuadraFormData = z.infer<typeof quadraSchema>

interface QuadraFormProps {
  onClose: () => void
  onSuccess: () => void
  quadraId?: string
}

export const QuadraForm = ({ onClose, onSuccess, quadraId }: QuadraFormProps) => {
  const [loading, setLoading] = useState(false)
  
  const {
    register,
    handleSubmit,
    setValue,
    watch,
    formState: { errors }
  } = useForm<QuadraFormData>({
    resolver: zodResolver(quadraSchema),
    defaultValues: {
      tem_cobertura: false,
      tem_iluminacao: false
    }
  })

  const onSubmit = async (data: QuadraFormData) => {
    setLoading(true)
    try {
      const { error } = await supabase
        .from('quadras')
        .insert([data])

      if (error) throw error

      toast.success('Quadra criada com sucesso!')
      onSuccess()
    } catch (error: any) {
      toast.error(error.message || 'Erro ao criar quadra')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Nova Quadra</DialogTitle>
        </DialogHeader>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="nome">Nome da Quadra</Label>
              <Input
                id="nome"
                {...register('nome')}
                placeholder="Ex: Quadra Central"
              />
              {errors.nome && (
                <p className="text-sm text-red-600">{errors.nome.message}</p>
              )}
            </div>

            <div>
              <Label htmlFor="numero">Número</Label>
              <Input
                id="numero"
                type="number"
                {...register('numero', { valueAsNumber: true })}
                placeholder="1"
              />
              {errors.numero && (
                <p className="text-sm text-red-600">{errors.numero.message}</p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="tipo_esporte">Modalidade</Label>
              <Select onValueChange={(value) => setValue('tipo_esporte', value as any)}>
                <SelectTrigger>
                  <SelectValue placeholder="Selecione a modalidade" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="beach_tennis">Beach Tennis</SelectItem>
                  <SelectItem value="padel">Padel</SelectItem>
                  <SelectItem value="tenis">Tênis</SelectItem>
                  <SelectItem value="futevolei">Futevôlei</SelectItem>
                </SelectContent>
              </Select>
              {errors.tipo_esporte && (
                <p className="text-sm text-red-600">{errors.tipo_esporte.message}</p>
              )}
            </div>

            <div>
              <Label htmlFor="tipo_piso">Tipo de Piso</Label>
              <Select onValueChange={(value) => setValue('tipo_piso', value)}>
                <SelectTrigger>
                  <SelectValue placeholder="Selecione o piso" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="areia">Areia</SelectItem>
                  <SelectItem value="saibro">Saibro</SelectItem>
                  <SelectItem value="sintetico">Sintético</SelectItem>
                  <SelectItem value="concreto">Concreto</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4">
            <div>
              <Label htmlFor="largura">Largura (m)</Label>
              <Input
                id="largura"
                type="number"
                step="0.1"
                {...register('largura', { valueAsNumber: true })}
                placeholder="16.0"
              />
            </div>

            <div>
              <Label htmlFor="comprimento">Comprimento (m)</Label>
              <Input
                id="comprimento"
                type="number"
                step="0.1"
                {...register('comprimento', { valueAsNumber: true })}
                placeholder="8.0"
              />
            </div>

            <div>
              <Label htmlFor="capacidade_maxima">Capacidade Máxima</Label>
              <Input
                id="capacidade_maxima"
                type="number"
                {...register('capacidade_maxima', { valueAsNumber: true })}
                placeholder="4"
              />
              {errors.capacidade_maxima && (
                <p className="text-sm text-red-600">{errors.capacidade_maxima.message}</p>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <Label htmlFor="valor_hora_normal">Valor/Hora Normal (R$)</Label>
              <Input
                id="valor_hora_normal"
                type="number"
                step="0.01"
                {...register('valor_hora_normal', { valueAsNumber: true })}
                placeholder="60.00"
              />
              {errors.valor_hora_normal && (
                <p className="text-sm text-red-600">{errors.valor_hora_normal.message}</p>
              )}
            </div>

            <div>
              <Label htmlFor="valor_hora_pico">Valor/Hora Pico (R$)</Label>
              <Input
                id="valor_hora_pico"
                type="number"
                step="0.01"
                {...register('valor_hora_pico', { valueAsNumber: true })}
                placeholder="80.00"
              />
              {errors.valor_hora_pico && (
                <p className="text-sm text-red-600">{errors.valor_hora_pico.message}</p>
              )}
            </div>
          </div>

          <div className="flex gap-6">
            <div className="flex items-center space-x-2">
              <Checkbox
                id="tem_cobertura"
                checked={watch('tem_cobertura')}
                onCheckedChange={(checked) => setValue('tem_cobertura', !!checked)}
              />
              <Label htmlFor="tem_cobertura">Tem cobertura</Label>
            </div>

            <div className="flex items-center space-x-2">
              <Checkbox
                id="tem_iluminacao"
                checked={watch('tem_iluminacao')}
                onCheckedChange={(checked) => setValue('tem_iluminacao', !!checked)}
              />
              <Label htmlFor="tem_iluminacao">Tem iluminação</Label>
            </div>
          </div>

          <div>
            <Label htmlFor="observacoes">Observações</Label>
            <Textarea
              id="observacoes"
              {...register('observacoes')}
              placeholder="Informações adicionais sobre a quadra..."
              rows={3}
            />
          </div>

          <div className="flex justify-end gap-3">
            <Button type="button" variant="outline" onClick={onClose}>
              Cancelar
            </Button>
            <Button type="submit" disabled={loading}>
              {loading ? 'Salvando...' : 'Salvar Quadra'}
            </Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
```

### TERCEIRO PASSO - CONFIGURAR RLS PARA QUADRAS:
```sql
-- Habilitar RLS para quadras
ALTER TABLE quadras ENABLE ROW LEVEL SECURITY;
ALTER TABLE quadras_bloqueios ENABLE ROW LEVEL SECURITY;
ALTER TABLE manutencoes ENABLE ROW LEVEL SECURITY;

-- Políticas para quadras
CREATE POLICY "quadras_tenant_isolation" ON quadras
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "bloqueios_tenant_isolation" ON quadras_bloqueios
FOR ALL USING (
  quadra_id IN (
    SELECT id FROM quadras 
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  )
);

CREATE POLICY "manutencoes_tenant_isolation" ON manutencoes
FOR ALL USING (
  quadra_id IN (
    SELECT id FROM quadras 
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  )
);
```

Implemente o sistema completo de quadras com interface moderna e funcionalidades de bloqueio/manutenção.
```

---

## PROMPT 5: SISTEMA DE AGENDAMENTOS

```
Desenvolva o sistema completo de agendamentos com calendário visual e validações inteligentes.

### PRIMEIRO PASSO - CRIAR TABELAS DE AGENDAMENTOS:

#### 1. TABELA DE AGENDAMENTOS:
```sql
CREATE TABLE agendamentos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id) ON DELETE CASCADE,
  
  -- Responsável pelo agendamento
  criado_por_id UUID REFERENCES usuarios(id),
  cliente_principal_id UUID REFERENCES usuarios(id),
  
  -- Data e horário
  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  duracao_minutos INTEGER GENERATED ALWAYS AS (
    EXTRACT(EPOCH FROM (hora_fim - hora_inicio)) / 60
  ) STORED,
  
  -- Tipo e configurações
  tipo tipo_agendamento NOT NULL DEFAULT 'avulso',
  modalidade tipo_esporte NOT NULL,
  
  -- Participantes
  participantes JSONB DEFAULT '[]',
  max_participantes INTEGER DEFAULT 4,
  
  -- Valores
  valor_total DECIMAL(8,2) NOT NULL DEFAULT 0,
  valor_por_pessoa DECIMAL(8,2),
  desconto_aplicado DECIMAL(8,2) DEFAULT 0,
  valor_final DECIMAL(8,2) GENERATED ALWAYS AS (valor_total - COALESCE(desconto_aplicado, 0)) STORED,
  
  -- Status e observações
  status status_agendamento NOT NULL DEFAULT 'pendente',
  status_pagamento status_pagamento NOT NULL DEFAULT 'pendente',
  observacoes TEXT,
  observacoes_internas TEXT,
  
  -- Recorrência
  e_recorrente BOOLEAN DEFAULT false,
  recorrencia_config JSONB DEFAULT '{}',
  agendamento_pai_id UUID REFERENCES agendamentos(id),
  
  -- Check-ins e controle
  permite_checkin BOOLEAN DEFAULT true,
  checkin_aberto_em TIMESTAMPTZ,
  checkin_fechado_em TIMESTAMPTZ,
  
  -- Comunicação
  notificacoes_enviadas JSONB DEFAULT '[]',
  lembrete_enviado BOOLEAN DEFAULT false,
  
  -- Cancelamento
  data_cancelamento TIMESTAMPTZ,
  motivo_cancelamento TEXT,
  cancelado_por_id UUID REFERENCES usuarios(id),
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Constraints
  CHECK (hora_fim > hora_inicio),
  CHECK (valor_total >= 0),
  CHECK (max_participantes > 0)
);
```

#### 2. TABELA DE CHECK-INS:
```sql
CREATE TABLE checkins (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE CASCADE,
  usuario_id UUID REFERENCES usuarios(id),
  tipo_checkin tipo_checkin NOT NULL,
  data_checkin TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  localizacao POINT,
  dispositivo_info JSONB,
  responsavel_checkin UUID REFERENCES usuarios(id),
  observacoes TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'presente',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 3. TABELA DE LISTA DE ESPERA:
```sql
CREATE TABLE lista_espera (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  quadra_id UUID REFERENCES quadras(id),
  cliente_id UUID REFERENCES usuarios(id),
  data_desejada DATE NOT NULL,
  hora_inicio_desejada TIME NOT NULL,
  hora_fim_desejada TIME NOT NULL,
  flexibilidade_horario JSONB,
  data_solicitacao TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  prioridade INTEGER NOT NULL DEFAULT 1,
  notificado BOOLEAN NOT NULL DEFAULT false,
  data_notificacao TIMESTAMPTZ,
  prazo_resposta TIMESTAMPTZ,
  aceite_automatico BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(20) NOT NULL DEFAULT 'aguardando',
  observacoes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### SEGUNDO PASSO - PÁGINA PRINCIPAL DE AGENDAMENTOS:

#### 1. DASHBOARD DE AGENDAMENTOS:
```tsx
// app/(dashboard)/agendamentos/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Calendar, Clock, Users, Plus } from 'lucide-react'
import { AgendamentoCalendar } from '@/components/agendamentos/AgendamentoCalendar'
import { AgendamentoForm } from '@/components/agendamentos/AgendamentoForm'
import { AgendamentosList } from '@/components/agendamentos/AgendamentosList'
import { format } from 'date-fns'
import { ptBR } from 'date-fns/locale'

interface AgendamentoResumo {
  total_hoje: number
  checkins_realizados: number
  receita_hoje: number
  ocupacao_media: number
}

export default function AgendamentosPage() {
  const [resumo, setResumo] = useState<AgendamentoResumo | null>(null)
  const [showForm, setShowForm] = useState(false)
  const [viewMode, setViewMode] = useState<'calendar' | 'list'>('calendar')
  const [selectedDate, setSelectedDate] = useState(new Date())

  useEffect(() => {
    fetchResumo()
  }, [])

  const fetchResumo = async () => {
    try {
      const hoje = format(new Date(), 'yyyy-MM-dd')
      
      // Buscar agendamentos de hoje
      const { data: agendamentosHoje } = await supabase
        .from('agendamentos')
        .select('*, checkins(*)')
        .eq('data_agendamento', hoje)
        .neq('status', 'cancelado')

      if (agendamentosHoje) {
        const totalHoje = agendamentosHoje.length
        const checkinsRealizados = agendamentosHoje.filter(
          ag => ag.checkins && ag.checkins.length > 0
        ).length
        const receitaHoje = agendamentosHoje.reduce(
          (sum, ag) => sum + (ag.valor_final || 0), 0
        )

        setResumo({
          total_hoje: totalHoje,
          checkins_realizados: checkinsRealizados,
          receita_hoje: receitaHoje,
          ocupacao_media: totalHoje > 0 ? (checkinsRealizados / totalHoje) * 100 : 0
        })
      }
    } catch (error) {
      console.error('Erro ao buscar resumo:', error)
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Agendamentos</h1>
          <p className="text-gray-600">
            {format(selectedDate, "EEEE, dd 'de' MMMM 'de' yyyy", { locale: ptBR })}
          </p>
        </div>
        <Button onClick={() => setShowForm(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Novo Agendamento
        </Button>
      </div>

      {/* Cards de Resumo */}
      {resumo && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Agendamentos Hoje</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{resumo.total_hoje}</div>
              <p className="text-xs text-muted-foreground">
                {resumo.total_hoje > 0 ? '+12% em relação a ontem' : 'Nenhum agendamento'}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Check-ins</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{resumo.checkins_realizados}</div>
              <p className="text-xs text-muted-foreground">
                de {resumo.total_hoje} agendamentos
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Receita Hoje</CardTitle>
              <Clock className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                R$ {resumo.receita_hoje.toFixed(2)}
              </div>
              <p className="text-xs text-muted-foreground">
                +15% em relação a ontem
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Taxa de Ocupação</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {resumo.ocupacao_media.toFixed(1)}%
              </div>
              <p className="text-xs text-muted-foreground">
                Média das quadras
              </p>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Controles de Visualização */}
      <div className="flex gap-2">
        <Button
          variant={viewMode === 'calendar' ? 'default' : 'outline'}
          onClick={() => setViewMode('calendar')}
        >
          <Calendar className="w-4 h-4 mr-2" />
          Calendário
        </Button>
        <Button
          variant={viewMode === 'list' ? 'default' : 'outline'}
          onClick={() => setViewMode('list')}
        >
          Lista
        </Button>
      </div>

      {/* Conteúdo Principal */}
      {viewMode === 'calendar' ? (
        <AgendamentoCalendar
          selectedDate={selectedDate}
          onDateChange={setSelectedDate}
          onNewAgendamento={() => setShowForm(true)}
        />
      ) : (
        <AgendamentosList
          selectedDate={selectedDate}
          onEdit={() => setShowForm(true)}
        />
      )}

      {/* Modal de Novo Agendamento */}
      {showForm && (
        <AgendamentoForm
          onClose={() => setShowForm(false)}
          onSuccess={() => {
            setShowForm(false)
            fetchResumo()
          }}
          initialDate={selectedDate}
        />
      )}
    </div>
  )
}
```

#### 2. COMPONENTE DE CALENDÁRIO:
```tsx
// components/agendamentos/AgendamentoCalendar.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import FullCalendar from '@fullcalendar/react'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'
import { ptBrLocale } from '@fullcalendar/core/locales/pt-br'

interface Agendamento {
  id: string
  data_agendamento: string
  hora_inicio: string
  hora_fim: string
  cliente_principal: { nome_completo: string }
  quadra: { nome: string }
  status: string
  modalidade: string
}

interface AgendamentoCalendarProps {
  selectedDate: Date
  onDateChange: (date: Date) => void
  onNewAgendamento: () => void
}

export const AgendamentoCalendar = ({
  selectedDate,
  onDateChange,
  onNewAgendamento
}: AgendamentoCalendarProps) => {
  const [events, setEvents] = useState<any[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchAgendamentos()
  }, [selectedDate])

  const fetchAgendamentos = async () => {
    try {
      const startDate = new Date(selectedDate)
      startDate.setDate(startDate.getDate() - 15)
      const endDate = new Date(selectedDate)
      endDate.setDate(endDate.getDate() + 15)

      const { data, error } = await supabase
        .from('agendamentos')
        .select(`
          *,
          cliente_principal:usuarios!cliente_principal_id(nome_completo),
          quadra:quadras(nome)
        `)
        .gte('data_agendamento', startDate.toISOString().split('T')[0])
        .lte('data_agendamento', endDate.toISOString().split('T')[0])
        .neq('status', 'cancelado')

      if (error) throw error

      const calendarEvents = (data || []).map((agendamento: Agendamento) => ({
        id: agendamento.id,
        title: `${agendamento.cliente_principal?.nome_completo} - ${agendamento.quadra?.nome}`,
        start: `${agendamento.data_agendamento}T${agendamento.hora_inicio}`,
        end: `${agendamento.data_agendamento}T${agendamento.hora_fim}`,
        backgroundColor: getStatusColor(agendamento.status),
        borderColor: getStatusColor(agendamento.status),
        extendedProps: {
          agendamento
        }
      }))

      setEvents(calendarEvents)
    } catch (error) {
      console.error('Erro ao buscar agendamentos:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'confirmado': return '#10b981'
      case 'pendente': return '#f59e0b'
      case 'realizado': return '#3b82f6'
      default: return '#6b7280'
    }
  }

  const handleDateClick = (arg: any) => {
    onDateChange(arg.date)
    onNewAgendamento()
  }

  const handleEventClick = (arg: any) => {
    // Abrir modal de detalhes do agendamento
    console.log('Agendamento clicado:', arg.event.extendedProps.agendamento)
  }

  if (loading) {
    return <div className="flex justify-center items-center h-96">Carregando calendário...</div>
  }

  return (
    <div className="bg-white rounded-lg border p-4">
      <FullCalendar
        plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
        headerToolbar={{
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
        }}
        initialView="timeGridWeek"
        locale={ptBrLocale}
        events={events}
        dateClick={handleDateClick}
        eventClick={handleEventClick}
        height="auto"
        slotMinTime="06:00:00"
        slotMaxTime="23:00:00"
        allDaySlot={false}
        weekends={true}
        businessHours={{
          daysOfWeek: [1, 2, 3, 4, 5, 6, 0],
          startTime: '06:00',
          endTime: '23:00'
        }}
        eventDisplay="block"
        dayMaxEvents={3}
        moreLinkClick="popover"
      />
    </div>
  )
}
```

### TERCEIRO PASSO - CONFIGURAR RLS PARA AGENDAMENTOS:
```sql
-- Habilitar RLS para agendamentos
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE lista_espera ENABLE ROW LEVEL SECURITY;

-- Políticas para agendamentos
CREATE POLICY "agendamentos_tenant_isolation" ON agendamentos
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);

CREATE POLICY "checkins_tenant_isolation" ON checkins
FOR ALL USING (
  agendamento_id IN (
    SELECT id FROM agendamentos 
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  )
);

CREATE POLICY "lista_espera_tenant_isolation" ON lista_espera
FOR ALL USING (
  arena_id IN (
    SELECT arena_id FROM usuarios 
    WHERE auth_id = auth.uid()
  )
);
```

Implemente o sistema completo de agendamentos com calendário interativo e validações em tempo real.
```