# VERANA BEACH TENNIS - ARQUITETURA TÉCNICA COMPLETA

**Versão: 1.0.0**  
**Data: 27/09/2025**  
**Stack: Next.js 14 + Supabase + React Native**

---

## STACK TECNOLÓGICO DETALHADO

### **FRONTEND WEB**
- **Framework:** Next.js 14 (App Router)
- **Linguagem:** TypeScript
- **Styling:** Tailwind CSS + Shadcn/UI
- **Estado:** Zustand + React Query
- **Formulários:** React Hook Form + Zod
- **Gráficos:** Recharts + Chart.js
- **Calendário:** FullCalendar.js
- **Mapas:** React Map GL (Mapbox)
- **Notificações:** React Hot Toast

### **MOBILE**
- **Framework:** React Native + Expo
- **Linguagem:** TypeScript
- **Navigation:** React Navigation v6
- **Estado:** Zustand + React Query
- **UI Components:** Native Base + Custom
- **Câmera:** Expo Camera (QR Code)
- **Localização:** Expo Location
- **Push:** Expo Notifications

### **BACKEND**
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth + RLS
- **Storage:** Supabase Storage
- **APIs:** Supabase Edge Functions
- **Real-time:** Supabase Realtime

### **INTEGRAÇÕES**
- **WhatsApp:** Evolution API
- **Pagamentos:** Asaas
- **Automações:** n8n
- **Email:** Resend
- **SMS:** Twilio

### **INFRAESTRUTURA**
- **Deploy Web:** Vercel
- **Deploy Mobile:** EAS Build + Expo Updates
- **Database:** Supabase Cloud
- **CDN:** Cloudflare
- **Monitoramento:** Sentry + PostHog
- **CI/CD:** GitHub Actions

---

## ESTRUTURA DE PASTAS - FRONTEND WEB

```
src/
├── app/                          # Next.js App Router
│   ├── (auth)/                   # Auth routes group
│   │   ├── login/
│   │   ├── register/
│   │   └── layout.tsx
│   ├── (dashboard)/              # Dashboard routes group
│   │   ├── arenas/
│   │   ├── quadras/
│   │   ├── agendamentos/
│   │   ├── aulas/
│   │   ├── financeiro/
│   │   ├── torneios/
│   │   ├── relatorios/
│   │   ├── configuracoes/
│   │   └── layout.tsx
│   ├── (super-admin)/           # Super Admin routes
│   │   ├── arenas/
│   │   ├── planos/
│   │   ├── faturamento/
│   │   └── layout.tsx
│   ├── api/                     # API routes
│   │   ├── webhooks/
│   │   │   ├── whatsapp/
│   │   │   ├── asaas/
│   │   │   └── n8n/
│   │   └── cron/
│   ├── globals.css
│   ├── layout.tsx
│   ├── loading.tsx
│   ├── error.tsx
│   └── not-found.tsx
├── components/                  # Componentes reutilizáveis
│   ├── ui/                     # Componentes base (Shadcn)
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── dialog.tsx
│   │   ├── table.tsx
│   │   └── ...
│   ├── layout/                 # Componentes de layout
│   │   ├── header.tsx
│   │   ├── sidebar.tsx
│   │   ├── footer.tsx
│   │   └── breadcrumb.tsx
│   ├── forms/                  # Formulários específicos
│   │   ├── arena-form.tsx
│   │   ├── quadra-form.tsx
│   │   ├── usuario-form.tsx
│   │   └── agendamento-form.tsx
│   ├── charts/                 # Componentes de gráficos
│   │   ├── revenue-chart.tsx
│   │   ├── occupancy-chart.tsx
│   │   └── performance-chart.tsx
│   ├── calendar/              # Componentes de calendário
│   │   ├── calendar-view.tsx
│   │   ├── event-modal.tsx
│   │   └── time-slot.tsx
│   ├── tables/                # Tabelas específicas
│   │   ├── data-table.tsx
│   │   ├── agendamentos-table.tsx
│   │   └── usuarios-table.tsx
│   ├── modals/                # Modais específicos
│   │   ├── check-in-modal.tsx
│   │   ├── payment-modal.tsx
│   │   └── confirmation-modal.tsx
│   └── common/                # Componentes comuns
│       ├── loading-spinner.tsx
│       ├── error-boundary.tsx
│       ├── empty-state.tsx
│       └── search-input.tsx
├── lib/                       # Utilitários e configurações
│   ├── supabase/             # Configurações Supabase
│   │   ├── client.ts
│   │   ├── server.ts
│   │   ├── middleware.ts
│   │   └── types.ts
│   ├── validations/          # Schemas Zod
│   │   ├── arena.ts
│   │   ├── usuario.ts
│   │   ├── agendamento.ts
│   │   └── index.ts
│   ├── utils/                # Funções utilitárias
│   │   ├── cn.ts
│   │   ├── date.ts
│   │   ├── currency.ts
│   │   ├── permissions.ts
│   │   └── export.ts
│   ├── hooks/                # Custom hooks
│   │   ├── use-auth.ts
│   │   ├── use-permissions.ts
│   │   ├── use-arena.ts
│   │   └── use-websocket.ts
│   ├── services/             # Serviços externos
│   │   ├── whatsapp.ts
│   │   ├── asaas.ts
│   │   ├── n8n.ts
│   │   └── email.ts
│   └── constants/            # Constantes
│       ├── navigation.ts
│       ├── permissions.ts
│       └── status.ts
├── store/                    # Estado global (Zustand)
│   ├── auth-store.ts
│   ├── arena-store.ts
│   ├── ui-store.ts
│   └── index.ts
├── types/                    # Types TypeScript
│   ├── database.ts          # Tipos do Supabase
│   ├── auth.ts
│   ├── arena.ts
│   ├── agendamento.ts
│   └── index.ts
└── styles/                   # Estilos globais
    ├── globals.css
    └── components.css
```

---

## ESTRUTURA DE PASTAS - MOBILE

```
src/
├── app/                      # Expo Router
│   ├── (auth)/
│   │   ├── login.tsx
│   │   └── _layout.tsx
│   ├── (tabs)/              # Bottom tabs
│   │   ├── home.tsx
│   │   ├── agendamentos.tsx
│   │   ├── aulas.tsx
│   │   ├── perfil.tsx
│   │   └── _layout.tsx
│   ├── modal/               # Modais full-screen
│   │   ├── check-in.tsx
│   │   └── qr-scanner.tsx
│   ├── _layout.tsx
│   └── +not-found.tsx
├── components/              # Componentes mobile
│   ├── ui/                 # Componentes base
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Card.tsx
│   │   └── Modal.tsx
│   ├── forms/              # Formulários mobile
│   │   ├── LoginForm.tsx
│   │   └── AgendamentoForm.tsx
│   ├── calendar/           # Calendário mobile
│   │   ├── MobileCalendar.tsx
│   │   └── TimeSlot.tsx
│   └── common/             # Componentes comuns
│       ├── LoadingSpinner.tsx
│       ├── EmptyState.tsx
│       └── ErrorBoundary.tsx
├── hooks/                  # Custom hooks mobile
│   ├── useAuth.ts
│   ├── useLocation.ts
│   ├── useCamera.ts
│   └── usePushNotifications.ts
├── services/               # Serviços mobile
│   ├── supabase.ts
│   ├── notifications.ts
│   └── location.ts
├── store/                  # Estado global mobile
│   ├── authStore.ts
│   └── appStore.ts
├── types/                  # Types compartilhados
│   └── index.ts
└── utils/                  # Utilitários mobile
    ├── constants.ts
    ├── helpers.ts
    └── validation.ts
```

---

## ARQUITETURA DE COMPONENTES

### **HIERARQUIA DE LAYOUTS**

```typescript
// Layout Principal
RootLayout
├── AuthLayout (rotas de autenticação)
│   ├── LoginPage
│   ├── RegisterPage
│   └── ForgotPasswordPage
├── DashboardLayout (rotas do dashboard)
│   ├── Sidebar
│   ├── Header
│   ├── Breadcrumb
│   └── PageContent
│       ├── ArenasPage
│       ├── QuadrasPage
│       ├── AgendamentosPage
│       ├── AulasPage
│       ├── FinanceiroPage
│       ├── TorneiosPage
│       ├── RelatoriosPage
│       └── ConfiguracoesPage
└── SuperAdminLayout (rotas super admin)
    ├── AdminSidebar
    ├── AdminHeader
    └── AdminContent
        ├── ArenasManagementPage
        ├── PlanosPage
        └── FaturamentoPage
```

### **COMPONENTES SMART vs DUMB**

```typescript
// Smart Components (com lógica)
export const AgendamentosPage = () => {
  const { agendamentos, loading } = useAgendamentos()
  const { user } = useAuth()
  // Lógica de negócio
  return <AgendamentosTable data={agendamentos} />
}

// Dumb Components (apenas UI)
export const AgendamentosTable = ({ data }: { data: Agendamento[] }) => {
  // Apenas renderização
  return <DataTable columns={columns} data={data} />
}
```

---

## GERENCIAMENTO DE ESTADO

### **ZUSTAND STORES**

```typescript
// auth-store.ts
interface AuthState {
  user: User | null
  session: Session | null
  loading: boolean
  signIn: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
  checkAuth: () => Promise<void>
}

// arena-store.ts
interface ArenaState {
  currentArena: Arena | null
  arenas: Arena[]
  setCurrentArena: (arena: Arena) => void
  loadArenas: () => Promise<void>
}

// ui-store.ts
interface UIState {
  sidebarOpen: boolean
  theme: 'light' | 'dark'
  notifications: Notification[]
  toggleSidebar: () => void
  setTheme: (theme: 'light' | 'dark') => void
  addNotification: (notification: Notification) => void
}
```

### **REACT QUERY CONFIGURATION**

```typescript
// lib/react-query.ts
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutos
      retry: 3,
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: 1,
    },
  },
})

// Custom hooks
export const useAgendamentos = (filters?: AgendamentoFilters) => {
  return useQuery({
    queryKey: ['agendamentos', filters],
    queryFn: () => fetchAgendamentos(filters),
    enabled: !!filters?.arenaId,
  })
}
```

---

## CONFIGURAÇÃO DO SUPABASE

### **DATABASE SCHEMA**

```sql
-- Row Level Security habilitado
ALTER TABLE arenas ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;

-- Políticas RLS
CREATE POLICY "Users can view own arena data" ON arenas
FOR SELECT USING (auth.uid() IN (
  SELECT usuario_id FROM usuarios 
  WHERE arena_id = arenas.id
));

CREATE POLICY "Arena admins can manage arena" ON arenas
FOR ALL USING (auth.uid() IN (
  SELECT usuario_id FROM usuarios 
  WHERE arena_id = arenas.id 
  AND tipo_usuario = 'admin'
));
```

### **SUPABASE TYPES**

```typescript
// types/database.ts
export interface Database {
  public: {
    Tables: {
      arenas: {
        Row: Arena
        Insert: ArenaInsert
        Update: ArenaUpdate
      }
      usuarios: {
        Row: Usuario
        Insert: UsuarioInsert
        Update: UsuarioUpdate
      }
      // ... outras tabelas
    }
  }
}

// lib/supabase/client.ts
export const supabase = createClient<Database>(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)
```

---

## SISTEMA DE PERMISSÕES

### **PERMISSÕES HIERÁRQUICAS**

```typescript
// lib/permissions.ts
export enum Role {
  SUPER_ADMIN = 'super_admin',
  ARENA_ADMIN = 'arena_admin',
  FUNCIONARIO = 'funcionario',
  PROFESSOR = 'professor',
  ALUNO = 'aluno',
}

export enum Permission {
  // Arenas
  ARENA_CREATE = 'arena:create',
  ARENA_READ = 'arena:read',
  ARENA_UPDATE = 'arena:update',
  ARENA_DELETE = 'arena:delete',
  
  // Quadras
  QUADRA_CREATE = 'quadra:create',
  QUADRA_READ = 'quadra:read',
  QUADRA_UPDATE = 'quadra:update',
  QUADRA_DELETE = 'quadra:delete',
  
  // Agendamentos
  AGENDAMENTO_CREATE = 'agendamento:create',
  AGENDAMENTO_READ = 'agendamento:read',
  AGENDAMENTO_UPDATE = 'agendamento:update',
  AGENDAMENTO_DELETE = 'agendamento:delete',
}

export const rolePermissions: Record<Role, Permission[]> = {
  [Role.SUPER_ADMIN]: [
    // Todas as permissões
    ...Object.values(Permission)
  ],
  [Role.ARENA_ADMIN]: [
    Permission.ARENA_READ,
    Permission.ARENA_UPDATE,
    Permission.QUADRA_CREATE,
    Permission.QUADRA_READ,
    Permission.QUADRA_UPDATE,
    Permission.QUADRA_DELETE,
    // ... outras permissões
  ],
  [Role.PROFESSOR]: [
    Permission.AGENDAMENTO_READ,
    Permission.AGENDAMENTO_CREATE,
    // ... permissões limitadas
  ],
  [Role.ALUNO]: [
    Permission.AGENDAMENTO_READ,
    Permission.AGENDAMENTO_CREATE,
    // ... permissões muito limitadas
  ],
}

// Hook para verificar permissões
export const usePermissions = () => {
  const { user } = useAuth()
  
  const hasPermission = (permission: Permission): boolean => {
    if (!user) return false
    const userPermissions = rolePermissions[user.role as Role] || []
    return userPermissions.includes(permission)
  }
  
  return { hasPermission }
}
```

---

## INTEGRAÇÕES EXTERNAS

### **WHATSAPP (Evolution API)**

```typescript
// services/whatsapp.ts
export class WhatsAppService {
  private baseURL: string
  private apiKey: string

  constructor(baseURL: string, apiKey: string) {
    this.baseURL = baseURL
    this.apiKey = apiKey
  }

  async sendMessage(to: string, message: string): Promise<void> {
    await fetch(`${this.baseURL}/message/sendText`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify({
        number: to,
        text: message,
      }),
    })
  }

  async sendTemplate(to: string, template: string, variables: any[]): Promise<void> {
    // Implementação de template
  }
}
```

### **ASAAS (Pagamentos)**

```typescript
// services/asaas.ts
export class AsaasService {
  private baseURL: string
  private apiKey: string

  constructor(environment: 'sandbox' | 'production') {
    this.baseURL = environment === 'production' 
      ? 'https://www.asaas.com/api/v3'
      : 'https://sandbox.asaas.com/api/v3'
    this.apiKey = process.env.ASAAS_API_KEY!
  }

  async createCustomer(data: CustomerData): Promise<Customer> {
    const response = await fetch(`${this.baseURL}/customers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'access_token': this.apiKey,
      },
      body: JSON.stringify(data),
    })
    return response.json()
  }

  async createPayment(data: PaymentData): Promise<Payment> {
    const response = await fetch(`${this.baseURL}/payments`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'access_token': this.apiKey,
      },
      body: JSON.stringify(data),
    })
    return response.json()
  }
}
```

### **N8N (Automações)**

```typescript
// services/n8n.ts
export class N8NService {
  private baseURL: string

  constructor() {
    this.baseURL = process.env.N8N_WEBHOOK_URL!
  }

  async triggerWorkflow(workflowId: string, data: any): Promise<void> {
    await fetch(`${this.baseURL}/webhook/${workflowId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    })
  }
}
```

---

## WEBHOOKS E APIs

### **WEBHOOK HANDLERS**

```typescript
// app/api/webhooks/asaas/route.ts
export async function POST(request: Request) {
  try {
    const payload = await request.json()
    const signature = request.headers.get('asaas-signature')
    
    // Verificar assinatura
    if (!verifyAsaasSignature(payload, signature)) {
      return new Response('Invalid signature', { status: 401 })
    }
    
    // Processar evento
    await handleAsaasEvent(payload)
    
    return new Response('OK', { status: 200 })
  } catch (error) {
    console.error('Asaas webhook error:', error)
    return new Response('Error', { status: 500 })
  }
}

// app/api/webhooks/whatsapp/route.ts
export async function POST(request: Request) {
  try {
    const payload = await request.json()
    
    // Processar mensagem recebida
    await handleWhatsAppMessage(payload)
    
    return new Response('OK', { status: 200 })
  } catch (error) {
    console.error('WhatsApp webhook error:', error)
    return new Response('Error', { status: 500 })
  }
}
```

---

## CONFIGURAÇÃO DE AMBIENTE

### **VARIÁVEIS DE AMBIENTE**

```bash
# .env.local
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Asaas
ASAAS_API_KEY=your_asaas_api_key
ASAAS_ENVIRONMENT=sandbox # ou production

# Evolution API (WhatsApp)
EVOLUTION_API_URL=your_evolution_api_url
EVOLUTION_API_KEY=your_evolution_api_key

# N8N
N8N_WEBHOOK_URL=your_n8n_webhook_url

# Outros
NEXTAUTH_SECRET=your_nextauth_secret
NEXTAUTH_URL=http://localhost:3000

# Email
RESEND_API_KEY=your_resend_api_key

# SMS
TWILIO_ACCOUNT_SID=your_twilio_sid
TWILIO_AUTH_TOKEN=your_twilio_token
```

---

## TESTES

### **ESTRUTURA DE TESTES**

```
__tests__/
├── components/           # Testes de componentes
├── pages/               # Testes de páginas
├── services/            # Testes de serviços
├── utils/               # Testes de utilitários
└── e2e/                 # Testes end-to-end
```

### **CONFIGURAÇÃO JEST**

```typescript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testPathIgnorePatterns: ['<rootDir>/.next/', '<rootDir>/node_modules/'],
}
```

---

## DEPLOY E CI/CD

### **GITHUB ACTIONS**

```yaml
# .github/workflows/deploy.yml
name: Deploy to Vercel

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test
      - run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

---

## MONITORAMENTO E LOGS

### **SENTRY CONFIGURATION**

```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs'

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 1.0,
  environment: process.env.NODE_ENV,
})
```

### **POSTHOG ANALYTICS**

```typescript
// lib/posthog.ts
import { PostHog } from 'posthog-js'

export const posthog = new PostHog(
  process.env.NEXT_PUBLIC_POSTHOG_KEY!,
  {
    api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST,
  }
)
```

---

**Status:** ✅ Arquitetura técnica completa definida  
**Próximo:** Wireframes e Mockups das telas principais