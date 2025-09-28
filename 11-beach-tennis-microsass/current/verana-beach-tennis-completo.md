# VERANA BEACH TENNIS - SISTEMA COMPLETO CRM/ERP
## Arquitetura Técnica + Estrutura Funcional + Interface Visual

**Versão: 1.1**  
**Data: 28/09/2025**  
**Tipo: Sistema Multi-tenant White-label**  
**Stack: Next.js 14 + Supabase + React Native**  
**Novo:** Wireframes e Mockups das Interfaces

---

## VISÃO GERAL DO SISTEMA

### Conceito
Sistema multi-tenant white-label para gestão completa de arenas de beach tennis, oferecendo diferentes planos de assinatura com módulos ativáveis conforme o nível contratado.

### Arquitetura
- **Multi-tenant**: Cada arena é um tenant isolado
- **White-label**: Customização visual por arena
- **Modular**: Ativação de funcionalidades por plano
- **Escalável**: Suporte a crescimento orgânico
- **Responsivo**: Interface adaptada para desktop e mobile

---

## DESIGN SYSTEM E LAYOUT

### **ESTRUTURA VISUAL GERAL (Desktop)**

```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER: Logo | Arena Atual | Notificações | Perfil              │
├─────────────────────────────────────────────────────────────────┤
│ SIDEBAR:        │ MAIN CONTENT AREA                             │
│ ├ Dashboard     │                                               │
│ ├ Agendamentos  │                                               │
│ ├ Quadras       │ ┌─ Breadcrumb ─────────────────────────────┐ │
│ ├ Pessoas       │ │ Home > Agendamentos > Hoje               │ │
│ ├ Aulas         │ └─────────────────────────────────────────────┘ │
│ ├ Financeiro    │                                               │
│ ├ Torneios      │ ┌─ PAGE TITLE & ACTIONS ──────────────────┐ │
│ ├ Relatórios    │ │ Agendamentos          [+ Novo] [Filtro] │ │
│ └ Configurações │ └─────────────────────────────────────────────┘ │
│                 │                                               │
│                 │ ┌─ CONTENT ─────────────────────────────────┐ │
│                 │ │     Conteúdo principal da página         │ │
│                 │ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### **COMPONENTES DE UI PADRONIZADOS**

#### Cards de Métricas:
```typescript
interface MetricCard {
  title: string
  value: string | number
  change: number // percentual
  trend: 'up' | 'down' | 'stable'
  icon: React.ReactNode
}
```

#### Status Indicators:
- ✅ **Confirmado/Ativo** - Verde
- ⏳ **Pendente/Aguardando** - Amarelo  
- 🔴 **Cancelado/Inativo** - Vermelho
- ⚠️ **Atenção/Manutenção** - Laranja

---

## STACK TECNOLÓGICA CONSOLIDADA

### **FRONTEND WEB**
- **Framework:** Next.js 14 (App Router)
- **Linguagem:** TypeScript
- **Styling:** Tailwind CSS + Shadcn/UI
- **Estado:** Zustand + React Query
- **Formulários:** React Hook Form + Zod
- **Gráficos:** Recharts + Chart.js
- **Calendário:** FullCalendar.js
- **Notificações:** React Hot Toast

### **MOBILE**
- **Framework:** React Native + Expo
- **Navigation:** React Navigation v6
- **Estado:** Zustand + React Query
- **UI:** Native Base + Custom Components
- **Câmera:** Expo Camera (QR Code)
- **Push:** Expo Notifications

### **BACKEND & INFRAESTRUTURA**
- **Database:** Supabase (PostgreSQL + RLS)
- **Auth:** Supabase Auth
- **Storage:** Supabase Storage
- **APIs:** Supabase Edge Functions
- **Real-time:** Supabase Realtime
- **Deploy Web:** Vercel
- **Deploy Mobile:** EAS Build

### **INTEGRAÇÕES EXTERNAS**
- **WhatsApp:** Evolution API
- **Pagamentos:** Asaas
- **Automações:** n8n
- **Email:** Resend
- **SMS:** Twilio
- **Monitoramento:** Sentry + PostHog

---

## HIERARQUIA DE USUÁRIOS E PERMISSÕES

### **1. SUPER ADMIN** (White-label Owner)
- Controle total de todas as arenas
- Ativação/desativação de módulos por arena
- Gestão de planos e cobrança
- Relatórios consolidados

### **2. ADMIN ARENA** (Cliente - Dono da Arena)
- Gestão completa da arena específica
- Acesso aos módulos liberados pelo plano
- Configuração de relatórios para equipe
- Gestão de usuários da arena

### **3. FUNCIONÁRIOS** (Staff da Arena)
- Acesso limitado conforme permissões
- Operações do dia-a-dia
- Relatórios operacionais básicos

### **4. PROFESSORES** (Instrutores)
- Gestão de aulas e alunos
- Relatórios de performance
- Agenda pessoal e comissões

### **5. ALUNOS/CLIENTES** (Usuários finais)
- App mobile para agendamentos
- Histórico pessoal
- Pagamentos e faturas

---

## PLANOS E MÓDULOS

| Módulo | Básico | Pro | Premium |
|--------|--------|-----|---------|
| Gestão de Arenas | ✅ | ✅ | ✅ |
| Gestão de Quadras | ✅ | ✅ | ✅ |
| Gestão de Pessoas | ✅ | ✅ | ✅ |
| Agendamentos | ✅ | ✅ | ✅ |
| Gestão de Aulas | ❌ | ✅ | ✅ |
| Gestão Financeira | Básico | ✅ | ✅ |
| Torneios e Eventos | ❌ | ❌ | ✅ |
| Relatórios Avançados | ❌ | ✅ | ✅ |
| Automações | ❌ | ❌ | ✅ |
| WhatsApp Integration | ❌ | ✅ | ✅ |

---

## ESTRUTURA DE MÓDULOS FUNCIONAIS

### 🔧 MÓDULO 0: SUPER ADMIN (White-label Management)

#### Funcionalidades Principais:
- **Gestão de Planos do Sistema**
- **Controle de Arenas e Assinaturas**
- **Faturamento Consolidado**
- **Relatórios Multi-tenant**

#### Estrutura de Dados:
```sql
-- Planos do Sistema
CREATE TABLE planos_sistema (
    id UUID PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor_mensal DECIMAL(8,2) NOT NULL,
    max_quadras INTEGER NOT NULL,
    max_usuarios INTEGER NOT NULL,
    modulos_inclusos JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);

-- Controle de Arenas
CREATE TABLE arenas_planos (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    plano_sistema_id UUID REFERENCES planos_sistema(id),
    modulos_ativos JSONB NOT NULL,
    data_inicio DATE NOT NULL,
    data_vencimento DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);
```

### 🏢 MÓDULO 1: GESTÃO DE ARENAS

#### Funcionalidades Principais:
- **Cadastro e Configuração da Arena**
- **Políticas de Negócio**
- **Customização Visual (White-label)**
- **Configurações Operacionais**

#### Estrutura de Dados:
```sql
CREATE TABLE arenas (
    id UUID PRIMARY KEY,
    tenant_id UUID UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    razao_social VARCHAR(200) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    endereco_completo JSONB NOT NULL,
    configuracoes JSONB,
    cores_tema JSONB,
    logo_url TEXT,
    horario_funcionamento JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo',
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 🏟️ MÓDULO 2: GESTÃO DE QUADRAS

#### Funcionalidades Principais:
- **Cadastro de Quadras**
- **Controle de Bloqueios e Manutenções**
- **Gestão de Equipamentos**
- **Histórico de Uso**

#### Estrutura de Dados:
```sql
CREATE TABLE quadras (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    nome VARCHAR(50) NOT NULL,
    tipo_esporte VARCHAR(20) NOT NULL,
    valor_hora_pico DECIMAL(8,2) NOT NULL,
    valor_hora_normal DECIMAL(8,2) NOT NULL,
    horarios_pico JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'ativa',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE quadras_bloqueios (
    id UUID PRIMARY KEY,
    quadra_id UUID REFERENCES quadras(id),
    tipo_bloqueio VARCHAR(20) NOT NULL,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL,
    motivo VARCHAR(200) NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);
```

### 👥 MÓDULO 3: GESTÃO DE PESSOAS

#### Funcionalidades Principais:
- **Cadastro de Usuários (Alunos, Professores, Funcionários)**
- **Controle de Permissões**
- **Histórico de Atividades**
- **Avaliações de Performance**

#### Estrutura de Dados:
```sql
CREATE TABLE usuarios (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    tipo_usuario VARCHAR(20) NOT NULL,
    nome_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    nivel_jogo VARCHAR(20),
    status VARCHAR(20) DEFAULT 'ativo',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE professores (
    usuario_id UUID PRIMARY KEY REFERENCES usuarios(id),
    valor_hora_aula DECIMAL(8,2) NOT NULL,
    percentual_comissao DECIMAL(5,2),
    disponibilidade JSONB NOT NULL,
    especialidades JSONB NOT NULL
);
```

### 📅 MÓDULO 4: AGENDAMENTOS

#### Funcionalidades Principais:
- **Reservas de Quadra**
- **Check-ins (QR Code, Geolocalização)**
- **Lista de Espera**
- **Agendamentos Recorrentes**

#### Estrutura de Dados:
```sql
CREATE TABLE agendamentos (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    quadra_id UUID REFERENCES quadras(id),
    cliente_id UUID REFERENCES usuarios(id),
    data_agendamento DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    valor_total DECIMAL(8,2) NOT NULL,
    status_agendamento VARCHAR(20) DEFAULT 'confirmado',
    status_pagamento VARCHAR(20) DEFAULT 'pendente',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE checkins (
    id UUID PRIMARY KEY,
    agendamento_id UUID REFERENCES agendamentos(id),
    usuario_id UUID REFERENCES usuarios(id),
    tipo_checkin VARCHAR(20) NOT NULL,
    data_checkin TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'presente'
);
```

### 🎓 MÓDULO 5: GESTÃO DE AULAS

#### Funcionalidades Principais:
- **Tipos de Aula e Modalidades**
- **Agendamento de Aulas**
- **Matrículas e Pacotes**
- **Planos de Aula**
- **Sistema de Reposições**

#### Estrutura de Dados:
```sql
CREATE TABLE tipos_aula (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    nome VARCHAR(100) NOT NULL,
    modalidade VARCHAR(20) NOT NULL,
    max_alunos INTEGER NOT NULL,
    duracao_minutos INTEGER NOT NULL,
    valor_aula DECIMAL(8,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);

CREATE TABLE aulas (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    tipo_aula_id UUID REFERENCES tipos_aula(id),
    professor_id UUID REFERENCES usuarios(id),
    quadra_id UUID REFERENCES quadras(id),
    data_aula DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    max_alunos INTEGER NOT NULL,
    valor_total DECIMAL(8,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'agendada'
);
```

### 💰 MÓDULO 6: GESTÃO FINANCEIRA

#### Funcionalidades Principais:
- **Planos e Mensalidades**
- **Contratos e Assinaturas**
- **Faturamento Automático**
- **Comissões de Professores**
- **Integração com Asaas**

#### Estrutura de Dados:
```sql
CREATE TABLE planos (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    nome VARCHAR(100) NOT NULL,
    tipo_plano VARCHAR(20) NOT NULL,
    valor DECIMAL(8,2) NOT NULL,
    beneficios JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);

CREATE TABLE contratos (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    cliente_id UUID REFERENCES usuarios(id),
    plano_id UUID REFERENCES planos(id),
    data_inicio DATE NOT NULL,
    valor_mensal DECIMAL(8,2) NOT NULL,
    dia_vencimento INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'ativo'
);

CREATE TABLE faturas (
    id UUID PRIMARY KEY,
    arena_id UUID REFERENCES arenas(id),
    cliente_id UUID REFERENCES usuarios(id),
    contrato_id UUID REFERENCES contratos(id),
    numero_fatura VARCHAR(20) NOT NULL,
    data_vencimento DATE NOT NULL,
    valor_final DECIMAL(8,2) NOT NULL,
    asaas_payment_id VARCHAR(50),
    status VARCHAR(20) DEFAULT 'pendente'
);
```

### 🏆 MÓDULO 7: TORNEIOS E EVENTOS

#### Funcionalidades Principais:
- **Criação e Gestão de Torneios**
- **Sistema de Inscrições**
- **Chaveamento Automático**
- **Ranking e Pontuação**

---

## ARQUITETURA TÉCNICA DETALHADA

### **ESTRUTURA DE PASTAS - FRONTEND WEB**

```
src/
├── app/                          # Next.js App Router
│   ├── (auth)/                   # Rotas de autenticação
│   ├── (dashboard)/              # Dashboard principal
│   │   ├── arenas/
│   │   ├── quadras/
│   │   ├── agendamentos/
│   │   ├── aulas/
│   │   ├── financeiro/
│   │   └── layout.tsx
│   ├── (super-admin)/           # Super Admin
│   └── api/                     # API routes
├── components/                  # Componentes reutilizáveis
│   ├── ui/                     # Shadcn components
│   ├── forms/                  # Formulários específicos
│   ├── charts/                 # Gráficos
│   └── modals/                 # Modais
├── lib/                        # Utilitários
│   ├── supabase/              # Config Supabase
│   ├── validations/           # Schemas Zod
│   ├── services/              # Serviços externos
│   └── hooks/                 # Custom hooks
└── store/                     # Estado global (Zustand)
```

### **CONFIGURAÇÃO DO SUPABASE**

#### Row Level Security (RLS):
```sql
-- Política para isolamento de tenants
CREATE POLICY "tenant_isolation" ON arenas
FOR ALL USING (
  auth.uid() IN (
    SELECT usuario_id FROM usuarios 
    WHERE arena_id = arenas.id
  )
);

-- Política para super admin
CREATE POLICY "super_admin_access" ON arenas
FOR ALL USING (
  auth.uid() IN (
    SELECT id FROM auth.users 
    WHERE raw_user_meta_data->>'role' = 'super_admin'
  )
);
```

### **SISTEMA DE PERMISSÕES**

```typescript
export enum Role {
  SUPER_ADMIN = 'super_admin',
  ARENA_ADMIN = 'arena_admin',
  FUNCIONARIO = 'funcionario',
  PROFESSOR = 'professor',
  ALUNO = 'aluno',
}

export enum Permission {
  ARENA_CREATE = 'arena:create',
  ARENA_READ = 'arena:read',
  ARENA_UPDATE = 'arena:update',
  QUADRA_MANAGE = 'quadra:manage',
  AGENDAMENTO_MANAGE = 'agendamento:manage',
  FINANCEIRO_READ = 'financeiro:read',
  RELATORIOS_ACCESS = 'relatorios:access',
}

export const rolePermissions: Record<Role, Permission[]> = {
  [Role.SUPER_ADMIN]: Object.values(Permission),
  [Role.ARENA_ADMIN]: [
    Permission.ARENA_READ,
    Permission.ARENA_UPDATE,
    Permission.QUADRA_MANAGE,
    Permission.AGENDAMENTO_MANAGE,
    Permission.FINANCEIRO_READ,
    Permission.RELATORIOS_ACCESS,
  ],
  // ... outras permissões
}
```

---

## INTEGRAÇÕES EXTERNAS

### **WHATSAPP (Evolution API)**
```typescript
export class WhatsAppService {
  async sendMessage(to: string, message: string): Promise<void> {
    await fetch(`${this.baseURL}/message/sendText`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify({ number: to, text: message }),
    })
  }

  async sendAgendamentoConfirmation(agendamento: Agendamento): Promise<void> {
    const message = `
🏐 *Agendamento Confirmado*

📅 Data: ${agendamento.data_agendamento}
⏰ Horário: ${agendamento.hora_inicio} - ${agendamento.hora_fim}
🏟️ Quadra: ${agendamento.quadra.nome}
💰 Valor: R$ ${agendamento.valor_total}

Para cancelar, responda CANCELAR
    `
    await this.sendMessage(agendamento.cliente.whatsapp, message)
  }
}
```

### **ASAAS (Pagamentos)**
```typescript
export class AsaasService {
  async createCustomer(userData: any): Promise<any> {
    return await this.request('/customers', 'POST', userData)
  }

  async createPayment(paymentData: any): Promise<any> {
    return await this.request('/payments', 'POST', paymentData)
  }

  async createSubscription(subscriptionData: any): Promise<any> {
    return await this.request('/subscriptions', 'POST', subscriptionData)
  }
}
```

---

## AUTOMAÇÕES COM N8N

### **Fluxos Principais:**
1. **Confirmação de Agendamento**
   - Trigger: Novo agendamento criado
   - Ações: Enviar WhatsApp + Email + SMS

2. **Cobrança Automática**
   - Trigger: Data de vencimento
   - Ações: Gerar fatura no Asaas + Notificar cliente

3. **Lembrete de Aula**
   - Trigger: 2h antes da aula
   - Ações: WhatsApp para aluno e professor

4. **Follow-up Inadimplência**
   - Trigger: Fatura vencida
   - Ações: Série de mensagens escalonadas

---

## DEPLOY E CI/CD

### **GitHub Actions**
```yaml
name: Deploy Verana

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run test
      - run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
```

---

## ROADMAP DE DESENVOLVIMENTO

### **FASE 1 - MVP (2-3 meses)**
- ✅ Autenticação e multi-tenancy
- ✅ Gestão básica de arenas e quadras
- ✅ Agendamentos simples
- ✅ Cadastro de usuários

### **FASE 2 - Core Features (2-3 meses)**
- ✅ Sistema financeiro completo
- ✅ Gestão de aulas
- ✅ Integração WhatsApp
- ✅ App mobile básico

### **FASE 3 - Advanced Features (3-4 meses)**
- ✅ Torneios e eventos
- ✅ Relatórios avançados
- ✅ Automações completas
- ✅ Sistema de ranking

### **FASE 4 - Scale & Optimize (Ongoing)**
- ✅ Performance optimization
- ✅ Advanced analytics
- ✅ AI/ML features
- ✅ Marketplace integrations

---

## MÉTRICAS E KPIs

### **Para o Super Admin:**
- ARR (Annual Recurring Revenue)
- Churn rate de arenas
- Uso por módulo
- Crescimento de usuários

### **Para Arena Admin:**
- Taxa de ocupação das quadras
- Receita mensal
- Inadimplência
- Satisfação dos clientes

### **Para Professores:**
- Número de aulas/mês
- Comissões geradas
- Avaliação dos alunos
- Taxa de retenção

---

**Status:** ✅ Documento consolidado criado  
**Próximo:** Implementação da arquitetura base

---

## INTERFACES PRINCIPAIS - WIREFRAMES

### **1. DASHBOARD PRINCIPAL**

#### Dashboard Admin Arena:
```
┌─ DASHBOARD VERANA BEACH TENNIS ──────────────────────────────────────┐
│ ┌─ MÉTRICAS HOJE ─────────────────────────────────────────────────┐  │
│ │ ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────────┐ │  │
│ │ │Agendamen. │ │ Check-ins │ │  Receita  │ │    Ocupação       │ │  │
│ │ │    24     │ │    18     │ │ R$ 1.250  │ │ ████████░░ 80%    │ │  │
│ │ │   ↑ 12%   │ │   ↓ 5%    │ │  ↑ 15%   │ │ Quadra 1: 90%     │ │  │
│ │ └───────────┘ └───────────┘ └───────────┘ │ Quadra 2: 70%     │ │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AGENDA HOJE ──────────────────┐ ┌─ ALERTAS E NOTIFICAÇÕES ─────┐  │
│ │ 08:00 - Quadra 1              │ │ ⚠️  3 pagamentos vencidos     │  │
│ │ João Silva (Beach Tennis)      │ │ 🔔  Aula cancelada - Quadra 2 │  │
│ │ [Check-in: ✅]                │ │ 💰  Nova mensalidade recebida  │  │
│ │ 09:00 - Quadra 2              │ │ 📅  Torneio em 3 dias        │  │
│ │ Maria Santos (Aula Grupo)      │ │ [Ver todas as notificações]   │  │
│ │ [Check-in: ⏳]                │ └───────────────────────────────┘  │
│ │ [Ver agenda completa]          │                                   │
│ └───────────────────────────────┘                                   │
└──────────────────────────────────────────────────────────────────────┘
```

### **2. AGENDAMENTOS - INTERFACE PRINCIPAL**

```
┌─ AGENDAMENTOS ───────────────────────────────────────────────────────┐
│ ┌─ FILTROS ──────────────────────────────────────────────────────┐   │
│ │ [Hoje ▼] [Todas Quadras ▼] [Todos Status ▼] [🔍 Buscar...]    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                    [+ Novo Agendamento] │
│                                                                      │
│ ┌─ AGENDAMENTOS HOJE (27/09/2025) ──────────────────────────────────┐ │
│ │ ┌──────────────────────────────────────────────────────────────┐ │ │
│ │ │ 08:00 - 09:00 | Quadra 1 | João Silva                       │ │ │
│ │ │ Beach Tennis Individual  | R$ 60,00 | ✅ CONFIRMADO         │ │ │
│ │ │ Check-in: ✅ 07:58 | Participantes: 2                      │ │ │
│ │ │ [👁️ Ver] [✏️ Editar] [❌ Cancelar] [💬 WhatsApp]            │ │ │
│ │ └──────────────────────────────────────────────────────────────┘ │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

### **3. CHECK-IN MOBILE**

```
┌─ CHECK-IN ─────────────────────────────────────────────────────┐
│ ┌─ AGENDAMENTO ─────────────────────────────────────────────┐  │
│ │ João Silva - Beach Tennis - Quadra 1                     │  │
│ │ 27/09/2025 - 08:00 às 09:00                             │  │
│ └──────────────────────────────────────────────────────────┘  │
│                                                                │
│ ┌─ MÉTODOS DE CHECK-IN ─────────────────────────────────────┐  │
│ │ ┌─────────────────────────────────────────────────────┐   │  │
│ │ │              📱 QR CODE                             │   │  │
│ │ │      ████ ██  ██ ████                              │   │  │
│ │ │      [📷 Escanear com câmera]                       │   │  │
│ │ └─────────────────────────────────────────────────────┘   │  │
│ │                                                           │  │
│ │ ┌─────────────────────────────────────────────────────┐   │  │
│ │ │              📍 LOCALIZAÇÃO                         │   │  │
│ │ │ Você está próximo à arena - 15 metros               │   │  │
│ │ │      [📍 Check-in por Localização]                  │   │  │
│ │ └─────────────────────────────────────────────────────┘   │  │
│ └───────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

### **4. GESTÃO FINANCEIRA**

```
┌─ FINANCEIRO ─────────────────────────────────────────────────────────┐
│ ┌─ RESUMO MENSAL (SETEMBRO 2025) ──────────────────────────────────┐  │
│ │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌───────────┐ │  │
│ │ │   RECEITA    │ │   DESPESAS   │ │     LUCRO    │ │INADIMPL.  │ │  │
│ │ │  R$ 28.450   │ │  R$ 12.800   │ │  R$ 15.650   │ │   3.2%    │ │  │
│ │ │    ↑ 15%     │ │    ↑ 8%      │ │    ↑ 22%     │ │  ↓ 1.1%   │ │  │
│ │ └──────────────┘ └──────────────┘ └──────────────┘ └───────────┘ │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ PRÓXIMOS VENCIMENTOS ─────────┐ ┌─ MOVIMENTAÇÕES RECENTES ──────┐  │
│ │ ┌─ HOJE (5) ──────────────────┐ │ │ ✅ João Silva - R$ 120 (PIX)  │  │
│ │ │ • João Silva - R$ 120       │ │ │ ✅ Maria Costa - R$ 80 (Cartão)│  │
│ │ │ • Maria Costa - R$ 150      │ │ │ ❌ Pedro Santos - R$ 150       │  │
│ │ │ [💰 Cobrar Todos]           │ │ │    Falha no cartão             │  │
│ │ └─────────────────────────────┘ │ │ [📋 Ver Todas]                │  │
│ │ ┌─ VENCIDOS (3) ──────────────┐ │ └────────────────────────────────┘  │
│ │ │ • Ana Silva - R$ 120        │ │                                    │
│ │ │   (3 dias em atraso)        │ │                                    │
│ │ │ [⚠️ Acionar Cobrança]       │ │                                    │
│ │ └─────────────────────────────┘ │                                    │
│ └─────────────────────────────────┘                                    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## COMPONENTES DE INTERFACE

### **Componentes Principais (Shadcn/UI)**

```typescript
// Componente de Métrica
interface MetricCardProps {
  title: string
  value: string | number
  change?: number
  trend?: 'up' | 'down' | 'stable'
  icon?: React.ReactNode
}

export const MetricCard: React.FC<MetricCardProps> = ({
  title,
  value,
  change,
  trend,
  icon
}) => {
  return (
    <Card className="p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-muted-foreground">{title}</p>
          <p className="text-2xl font-bold">{value}</p>
          {change && (
            <p className={`text-xs ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
              {trend === 'up' ? '↑' : '↓'} {Math.abs(change)}%
            </p>
          )}
        </div>
        {icon && <div className="text-muted-foreground">{icon}</div>}
      </div>
    </Card>
  )
}

// Componente de Status
export const StatusBadge: React.FC<{ status: string }> = ({ status }) => {
  const variants = {
    confirmado: 'bg-green-100 text-green-800',
    pendente: 'bg-yellow-100 text-yellow-800',
    cancelado: 'bg-red-100 text-red-800',
    manutencao: 'bg-orange-100 text-orange-800'
  }
  
  return (
    <Badge className={variants[status] || 'bg-gray-100 text-gray-800'}>
      {status.toUpperCase()}
    </Badge>
  )
}
```

---

## FLUXOS DE USUÁRIO (UX)

### **Fluxo de Agendamento (Cliente)**
1. **Login** → Dashboard do cliente
2. **Selecionar data/hora** → Calendário disponível
3. **Escolher quadra** → Visualizar opções
4. **Confirmar dados** → Revisar agendamento
5. **Pagamento** → PIX/Cartão/Crédito
6. **Confirmação** → WhatsApp + Email

### **Fluxo de Check-in (Mobile)**
1. **Abrir app** → Lista de agendamentos
2. **Selecionar agendamento** → Detalhes
3. **Escolher método** → QR Code/GPS/Manual
4. **Confirmar presença** → Check-in realizado
5. **Liberação** → Acesso à quadra

### **Fluxo de Cobrança (Admin)**
1. **Dashboard financeiro** → Vencimentos
2. **Selecionar clientes** → Filtros
3. **Gerar cobranças** → Asaas integration
4. **Enviar notificações** → WhatsApp/Email/SMS
5. **Acompanhar pagamentos** → Status em tempo real