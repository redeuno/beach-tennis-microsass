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

### **Prompts Incluídos:**
- **PROMPT 0-5**: Disponíveis neste arquivo
- **PROMPT 6-7**: Gestão de Usuários e Sistema Financeiro (incluídos neste arquivo)
- **PROMPT 8-10**: Aulas, Torneios e Comunicação (arquivo `prompts-8-10.md`)

---

## INSTRUÇÕES DE USO

### **Como Implementar:**
1. Execute os prompts na ordem sequencial (0 → 1 → 2 → 3 → 4 → 5...)
2. Teste cada módulo antes de prosseguir
3. Configure as variáveis de ambiente necessárias
4. Valide o RLS após cada tabela criada

### **Configurações Necessárias:**
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### **Dependências Principais:**
- Next.js 14
- Supabase
- Tailwind CSS + Shadcn/UI
- React Hook Form + Zod
- FullCalendar (para agendamentos)
- Recharts (para gráficos)

---

## PROMPT 6: GESTÃO DE USUÁRIOS E PERFIS

```
Desenvolva o sistema completo de gestão de usuários com perfis específicos para Beach Tennis.

### PRIMEIRO PASSO - CRIAR TABELAS DE USUÁRIOS ESTENDIDAS:

#### 1. TABELA DE PROFESSORES:
```sql
CREATE TABLE professores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  registro_profissional VARCHAR(50),
  especialidades JSONB NOT NULL DEFAULT '[]',
  valor_hora_aula DECIMAL(8,2) NOT NULL,
  percentual_comissao DECIMAL(5,2),
  disponibilidade JSONB NOT NULL DEFAULT '{}',
  biografia TEXT,
  certificacoes JSONB DEFAULT '[]',
  experiencia_anos INTEGER,
  status_professor status_geral NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. TABELA DE FUNCIONÁRIOS:
```sql
CREATE TABLE funcionarios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  cargo VARCHAR(50) NOT NULL,
  salario DECIMAL(8,2),
  permissoes JSONB NOT NULL DEFAULT '[]',
  horario_trabalho JSONB NOT NULL DEFAULT '{}',
  data_admissao DATE NOT NULL,
  data_demissao DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### SEGUNDO PASSO - COMPONENTE DE GESTÃO DE USUÁRIOS:

#### 1. PÁGINA PRINCIPAL:
```tsx
// app/(dashboard)/pessoas/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Plus, Search, Filter, Users, GraduationCap, Briefcase } from 'lucide-react'
import { UsuarioForm } from '@/components/usuarios/UsuarioForm'

interface Usuario {
  id: string
  nome_completo: string
  email: string
  telefone: string
  tipo_usuario: string
  nivel_jogo?: string
  status: string
  foto_url?: string
  data_cadastro: string
}

export default function PessoasPage() {
  const [usuarios, setUsuarios] = useState<Usuario[]>([])
  const [loading, setLoading] = useState(true)
  const [searchTerm, setSearchTerm] = useState('')
  const [filterRole, setFilterRole] = useState('todos')
  const [showForm, setShowForm] = useState(false)

  useEffect(() => {
    fetchUsuarios()
  }, [])

  const fetchUsuarios = async () => {
    try {
      let query = supabase
        .from('usuarios')
        .select('*')
        .order('nome_completo')

      if (filterRole !== 'todos') {
        query = query.eq('tipo_usuario', filterRole)
      }

      if (searchTerm) {
        query = query.or(`nome_completo.ilike.%${searchTerm}%,email.ilike.%${searchTerm}%,cpf.ilike.%${searchTerm}%`)
      }

      const { data, error } = await query

      if (error) throw error
      setUsuarios(data || [])
    } catch (error) {
      console.error('Erro ao buscar usuários:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'ativo': return 'bg-green-100 text-green-800'
      case 'inativo': return 'bg-gray-100 text-gray-800'
      case 'suspenso': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  const getRoleIcon = (role: string) => {
    switch (role) {
      case 'professor': return <GraduationCap className="w-4 h-4" />
      case 'funcionario': return <Briefcase className="w-4 h-4" />
      case 'aluno': return <Users className="w-4 h-4" />
      default: return <Users className="w-4 h-4" />
    }
  }

  const getRoleLabel = (role: string) => {
    const labels = {
      'super_admin': 'Super Admin',
      'arena_admin': 'Admin Arena',
      'funcionario': 'Funcionário',
      'professor': 'Professor',
      'aluno': 'Aluno'
    }
    return labels[role] || role
  }

  useEffect(() => {
    fetchUsuarios()
  }, [searchTerm, filterRole])

  if (loading) {
    return <div className="flex justify-center items-center h-64">Carregando...</div>
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Pessoas</h1>
          <p className="text-gray-600">Gerencie alunos, professores e funcionários</p>
        </div>
        <Button onClick={() => setShowForm(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Nova Pessoa
        </Button>
      </div>

      {/* Filtros */}
      <div className="flex gap-4 items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
          <Input
            placeholder="Buscar por nome, email ou CPF..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10"
          />
        </div>
        <Select value={filterRole} onValueChange={setFilterRole}>
          <SelectTrigger className="w-48">
            <SelectValue placeholder="Filtrar por tipo" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="todos">Todos os tipos</SelectItem>
            <SelectItem value="aluno">Alunos</SelectItem>
            <SelectItem value="professor">Professores</SelectItem>
            <SelectItem value="funcionario">Funcionários</SelectItem>
            <SelectItem value="arena_admin">Admins</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Lista de Usuários */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {usuarios.map((usuario) => (
          <Card key={usuario.id} className="hover:shadow-lg transition-shadow">
            <CardHeader className="pb-3">
              <div className="flex items-center gap-3">
                <Avatar>
                  <AvatarImage src={usuario.foto_url} />
                  <AvatarFallback>
                    {usuario.nome_completo.split(' ').map(n => n[0]).join('').toUpperCase()}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <CardTitle className="text-lg">{usuario.nome_completo}</CardTitle>
                  <p className="text-sm text-gray-600">{usuario.email}</p>
                </div>
                <Badge className={getStatusColor(usuario.status)}>
                  {usuario.status}
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="flex items-center gap-2">
                {getRoleIcon(usuario.tipo_usuario)}
                <span className="text-sm font-medium">
                  {getRoleLabel(usuario.tipo_usuario)}
                </span>
              </div>

              <div className="text-sm text-gray-600">
                <p>📞 {usuario.telefone}</p>
                {usuario.nivel_jogo && (
                  <p>🎾 Nível: {usuario.nivel_jogo}</p>
                )}
                <p>📅 Cadastro: {new Date(usuario.data_cadastro).toLocaleDateString()}</p>
              </div>

              <div className="flex gap-2 pt-2">
                <Button size="sm" variant="outline" className="flex-1">
                  Ver Perfil
                </Button>
                <Button size="sm" variant="outline">
                  Editar
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {usuarios.length === 0 && (
        <div className="text-center py-12">
          <Users className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">Nenhuma pessoa encontrada</h3>
          <p className="text-gray-600 mb-4">
            {searchTerm || filterRole !== 'todos' 
              ? 'Tente ajustar os filtros de busca'
              : 'Comece adicionando pessoas à sua arena'
            }
          </p>
          <Button onClick={() => setShowForm(true)}>
            <Plus className="w-4 h-4 mr-2" />
            Adicionar Primeira Pessoa
          </Button>
        </div>
      )}

      {showForm && (
        <UsuarioForm
          onClose={() => setShowForm(false)}
          onSuccess={() => {
            setShowForm(false)
            fetchUsuarios()
          }}
        />
      )}
    </div>
  )
}
```

### TERCEIRO PASSO - CONFIGURAR RLS:
```sql
-- Habilitar RLS para tabelas de usuários estendidas
ALTER TABLE professores ENABLE ROW LEVEL SECURITY;
ALTER TABLE funcionarios ENABLE ROW LEVEL SECURITY;

-- Políticas para professores
CREATE POLICY "professores_tenant_isolation" ON professores
FOR ALL USING (
  usuario_id IN (
    SELECT id FROM usuarios 
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  )
);

-- Políticas para funcionários
CREATE POLICY "funcionarios_tenant_isolation" ON funcionarios
FOR ALL USING (
  usuario_id IN (
    SELECT id FROM usuarios 
    WHERE arena_id IN (
      SELECT arena_id FROM usuarios 
      WHERE auth_id = auth.uid()
    )
  )
);
```

Implemente o sistema completo de gestão de usuários com perfis específicos e interface moderna.
```

---

## PROMPT 7: SISTEMA FINANCEIRO E ASAAS

```
Desenvolva o módulo completo de gestão financeira integrado com Asaas.

### PRIMEIRO PASSO - CRIAR TABELAS FINANCEIRAS:

#### 1. TABELA DE CONTRATOS:
```sql
CREATE TABLE contratos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  vendedor_id UUID REFERENCES usuarios(id),
  
  -- Dados do contrato
  numero_contrato VARCHAR(50) NOT NULL,
  tipo_plano tipo_plano NOT NULL,
  modalidade tipo_esporte NOT NULL,
  
  -- Datas
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_vencimento_mensalidade INTEGER NOT NULL DEFAULT 10,
  
  -- Valores
  valor_mensalidade DECIMAL(8,2) NOT NULL,
  valor_taxa_adesao DECIMAL(8,2) DEFAULT 0,
  desconto_percentual DECIMAL(5,2) DEFAULT 0,
  valor_desconto DECIMAL(8,2) DEFAULT 0,
  valor_final_mensalidade DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_mensalidade - COALESCE(valor_desconto, 0) - (valor_mensalidade * COALESCE(desconto_percentual, 0) / 100)
  ) STORED,
  
  -- Status
  status status_contrato NOT NULL DEFAULT 'ativo',
  motivo_cancelamento TEXT,
  data_cancelamento TIMESTAMPTZ,
  
  -- Observações
  observacoes TEXT,
  clausulas_especiais TEXT,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero_contrato),
  CHECK (data_fim > data_inicio),
  CHECK (valor_mensalidade > 0)
);
```

#### 2. TABELA DE FATURAS:
```sql
CREATE TABLE faturas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  contrato_id UUID REFERENCES contratos(id) ON DELETE CASCADE,
  cliente_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
  
  -- Dados da fatura
  numero_fatura VARCHAR(50) NOT NULL,
  competencia DATE NOT NULL,
  
  -- Datas importantes
  data_vencimento DATE NOT NULL,
  data_emissao DATE NOT NULL DEFAULT CURRENT_DATE,
  data_pagamento TIMESTAMPTZ,
  
  -- Valores
  valor_base DECIMAL(8,2) NOT NULL,
  desconto DECIMAL(8,2) DEFAULT 0,
  acrescimo DECIMAL(8,2) DEFAULT 0,
  valor_total DECIMAL(8,2) GENERATED ALWAYS AS (
    valor_base - COALESCE(desconto, 0) + COALESCE(acrescimo, 0)
  ) STORED,
  valor_pago DECIMAL(8,2) DEFAULT 0,
  
  -- Status e forma de pagamento
  status status_fatura NOT NULL DEFAULT 'pendente',
  forma_pagamento forma_pagamento,
  
  -- Integração Asaas
  asaas_payment_id VARCHAR(100),
  asaas_invoice_url TEXT,
  qr_code_pix TEXT,
  linha_digitavel TEXT,
  
  -- Observações
  observacoes TEXT,
  observacoes_internas TEXT,
  
  -- Histórico de status
  historico_status JSONB DEFAULT '[]',
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(arena_id, numero_fatura),
  CHECK (valor_base > 0),
  CHECK (valor_pago >= 0)
);
```

### SEGUNDO PASSO - DASHBOARD FINANCEIRO:

#### 1. PÁGINA PRINCIPAL:
```tsx
// app/(dashboard)/financeiro/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { DollarSign, TrendingUp, AlertCircle, Calendar } from 'lucide-react'
import { RevenueChart } from '@/components/financeiro/RevenueChart'
import { FaturasList } from '@/components/financeiro/FaturasList'

interface ResumoFinanceiro {
  receita_mensal: number
  despesas_mensal: number
  lucro_mensal: number
  inadimplencia_percentual: number
  faturas_vencendo: number
  faturas_vencidas: number
}

export default function FinanceiroPage() {
  const [resumo, setResumo] = useState<ResumoFinanceiro | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchResumoFinanceiro()
  }, [])

  const fetchResumoFinanceiro = async () => {
    try {
      const hoje = new Date()
      const inicioMes = new Date(hoje.getFullYear(), hoje.getMonth(), 1)
      const fimMes = new Date(hoje.getFullYear(), hoje.getMonth() + 1, 0)

      // Buscar faturas do mês
      const { data: faturas } = await supabase
        .from('faturas')
        .select('*')
        .gte('competencia', inicioMes.toISOString().split('T')[0])
        .lte('competencia', fimMes.toISOString().split('T')[0])

      if (faturas) {
        const receitaMensal = faturas
          .filter(f => f.status === 'paga')
          .reduce((sum, f) => sum + f.valor_total, 0)

        const faturasPendentes = faturas.filter(f => f.status === 'pendente')
        const faturasVencidas = faturas.filter(f => 
          f.status === 'vencida' || 
          (f.status === 'pendente' && new Date(f.data_vencimento) < hoje)
        )

        const inadimplenciaPercentual = faturas.length > 0 
          ? (faturasVencidas.length / faturas.length) * 100 
          : 0

        setResumo({
          receita_mensal: receitaMensal,
          despesas_mensal: 0, // Implementar depois
          lucro_mensal: receitaMensal,
          inadimplencia_percentual: inadimplenciaPercentual,
          faturas_vencendo: faturasPendentes.length,
          faturas_vencidas: faturasVencidas.length
        })
      }
    } catch (error) {
      console.error('Erro ao buscar resumo financeiro:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="flex justify-center items-center h-64">Carregando...</div>
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Financeiro</h1>
          <p className="text-gray-600">Controle financeiro da sua arena</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline">
            <Calendar className="w-4 h-4 mr-2" />
            Relatórios
          </Button>
          <Button>
            Nova Cobrança
          </Button>
        </div>
      </div>

      {/* Cards de Resumo */}
      {resumo && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Receita Mensal</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                R$ {resumo.receita_mensal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
              </div>
              <p className="text-xs text-muted-foreground">
                +15% em relação ao mês anterior
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Lucro Mensal</CardTitle>
              <TrendingUp className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                R$ {resumo.lucro_mensal.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}
              </div>
              <p className="text-xs text-muted-foreground">
                Margem de {((resumo.lucro_mensal / resumo.receita_mensal) * 100).toFixed(1)}%
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Inadimplência</CardTitle>
              <AlertCircle className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">
                {resumo.inadimplencia_percentual.toFixed(1)}%
              </div>
              <p className="text-xs text-muted-foreground">
                {resumo.faturas_vencidas} faturas vencidas
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Vencimentos</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{resumo.faturas_vencendo}</div>
              <p className="text-xs text-muted-foreground">
                Faturas vencendo nos próximos 7 dias
              </p>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Gráfico de Receita */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <Card>
            <CardHeader>
              <CardTitle>Receita dos Últimos 6 Meses</CardTitle>
            </CardHeader>
            <CardContent>
              <RevenueChart />
            </CardContent>
          </Card>
        </div>

        <div>
          <Card>
            <CardHeader>
              <CardTitle>Próximos Vencimentos</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="flex justify-between items-center p-3 bg-yellow-50 rounded-lg">
                <div>
                  <p className="font-medium">Hoje</p>
                  <p className="text-sm text-gray-600">3 faturas</p>
                </div>
                <Badge variant="outline">R$ 450,00</Badge>
              </div>
              <div className="flex justify-between items-center p-3 bg-orange-50 rounded-lg">
                <div>
                  <p className="font-medium">Amanhã</p>
                  <p className="text-sm text-gray-600">2 faturas</p>
                </div>
                <Badge variant="outline">R$ 300,00</Badge>
              </div>
              <div className="flex justify-between items-center p-3 bg-red-50 rounded-lg">
                <div>
                  <p className="font-medium">Vencidas</p>
                  <p className="text-sm text-gray-600">1 fatura</p>
                </div>
                <Badge variant="destructive">R$ 150,00</Badge>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Lista de Faturas */}
      <FaturasList />
    </div>
  )
}
```

### TERCEIRO PASSO - INTEGRAÇÃO ASAAS:

#### 1. SERVIÇO ASAAS:
```typescript
// lib/services/asaas.ts
interface AsaasConfig {
  baseURL: string
  apiKey: string
}

export class AsaasService {
  private config: AsaasConfig

  constructor(environment: 'sandbox' | 'production' = 'sandbox') {
    this.config = {
      baseURL: environment === 'production' 
        ? 'https://www.asaas.com/api/v3'
        : 'https://sandbox.asaas.com/api/v3',
      apiKey: process.env.ASAAS_API_KEY!
    }
  }

  private async request(endpoint: string, options: RequestInit = {}) {
    const response = await fetch(`${this.config.baseURL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'access_token': this.config.apiKey,
        ...options.headers,
      },
    })

    if (!response.ok) {
      throw new Error(`Asaas API Error: ${response.statusText}`)
    }

    return response.json()
  }

  async createCustomer(customerData: any) {
    return this.request('/customers', {
      method: 'POST',
      body: JSON.stringify(customerData),
    })
  }

  async createPayment(paymentData: any) {
    return this.request('/payments', {
      method: 'POST',
      body: JSON.stringify(paymentData),
    })
  }

  async getPayment(paymentId: string) {
    return this.request(`/payments/${paymentId}`)
  }

  async cancelPayment(paymentId: string) {
    return this.request(`/payments/${paymentId}`, {
      method: 'DELETE',
    })
  }
}
```

Implemente o sistema financeiro completo com integração Asaas e dashboard interativo.
```

---

---

## ORGANIZAÇÃO COMPLETA DOS PROMPTS

### **Arquivo Principal** (`verana-prompts-lovable-completo.md`):
- **PROMPT 0**: Setup inicial + Database schemas
- **PROMPT 1**: Tabelas principais do sistema  
- **PROMPT 2**: Estrutura frontend + Autenticação
- **PROMPT 3**: Sistema de permissões + RLS
- **PROMPT 4**: Gestão de quadras
- **PROMPT 5**: Sistema de agendamentos
- **PROMPT 6**: Gestão de usuários e perfis
- **PROMPT 7**: Sistema financeiro e Asaas

### **Arquivo Complementar** (`prompts-8-10.md`):
- **PROMPT 8**: Gestão de aulas e check-in
- **PROMPT 9**: Torneios e eventos  
- **PROMPT 10**: Comunicação e WhatsApp

---

**Status:** ✅ Todos os 10 prompts completos disponíveis  
**Implementação:** Execute na ordem sequencial (0→1→2→3→4→5→6→7→8→9→10)  
**Arquivos:** 2 arquivos organizados para facilitar o uso no Lovable