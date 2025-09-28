# PROMPTS 8, 9 e 10 - VERANA BEACH TENNIS

## PROMPT 8: GESTÃO DE AULAS E CHECK-IN

```
Desenvolva o sistema completo de gestão de aulas com check-in avançado.

### PRIMEIRO PASSO - CRIAR TABELAS DE AULAS:

#### 1. TABELA DE AULAS:
```sql
CREATE TABLE aulas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  agendamento_id UUID REFERENCES agendamentos(id) ON DELETE CASCADE,
  professor_id UUID REFERENCES usuarios(id) ON DELETE SET NULL,
  
  -- Configurações da aula
  nome VARCHAR(150),
  tipo_aula VARCHAR(50) NOT NULL,
  modalidade tipo_esporte NOT NULL,
  nivel_aula nivel_jogo,
  
  -- Alunos
  alunos JSONB DEFAULT '[]',
  max_alunos INTEGER DEFAULT 4,
  min_alunos INTEGER DEFAULT 1,
  
  -- Conteúdo programático
  objetivos TEXT,
  conteudo_programatico TEXT,
  material_necessario JSONB DEFAULT '[]',
  
  -- Valores e duração
  valor_aula DECIMAL(8,2) NOT NULL,
  duracao_minutos INTEGER NOT NULL DEFAULT 60,
  
  -- Check-in e presença
  checkin_habilitado BOOLEAN DEFAULT true,
  checkin_config JSONB DEFAULT '{}',
  presencas JSONB DEFAULT '[]',
  
  -- Status
  status status_agendamento NOT NULL DEFAULT 'confirmado',
  realizada BOOLEAN DEFAULT false,
  data_realizacao TIMESTAMPTZ,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CHECK (max_alunos >= min_alunos),
  CHECK (valor_aula >= 0)
);
```

### SEGUNDO PASSO - COMPONENTE DE CHECK-IN:

#### 1. INTERFACE DE CHECK-IN:
```tsx
// components/aulas/CheckInInterface.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { QrCode, MapPin, User, Clock } from 'lucide-react'
import { QRCodeGenerator } from './QRCodeGenerator'
import { GeolocationChecker } from './GeolocationChecker'

interface Aula {
  id: string
  nome: string
  professor: { nome_completo: string }
  quadra: { nome: string }
  data_aula: string
  hora_inicio: string
  hora_fim: string
  alunos: string[]
  presencas: any[]
  status: string
}

interface CheckInInterfaceProps {
  aulaId: string
}

export const CheckInInterface = ({ aulaId }: CheckInInterfaceProps) => {
  const [aula, setAula] = useState<Aula | null>(null)
  const [loading, setLoading] = useState(true)
  const [checkInMethod, setCheckInMethod] = useState<'qr' | 'geo' | 'manual'>('qr')

  useEffect(() => {
    fetchAula()
  }, [aulaId])

  const fetchAula = async () => {
    try {
      const { data, error } = await supabase
        .from('aulas')
        .select(`
          *,
          professor:usuarios!professor_id(nome_completo),
          agendamento:agendamentos!agendamento_id(
            quadra:quadras(nome)
          )
        `)
        .eq('id', aulaId)
        .single()

      if (error) throw error
      setAula(data)
    } catch (error) {
      console.error('Erro ao buscar aula:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleCheckIn = async (alunoId: string, method: string) => {
    try {
      // Registrar check-in
      const { error } = await supabase
        .from('checkins')
        .insert([{
          agendamento_id: aula?.agendamento_id,
          usuario_id: alunoId,
          tipo_checkin: method,
          data_checkin: new Date().toISOString(),
          status: 'presente'
        }])

      if (error) throw error

      // Atualizar presença na aula
      const presencasAtualizadas = [...(aula?.presencas || []), {
        aluno_id: alunoId,
        presente: true,
        data_checkin: new Date().toISOString(),
        metodo: method
      }]

      await supabase
        .from('aulas')
        .update({ presencas: presencasAtualizadas })
        .eq('id', aulaId)

      fetchAula() // Recarregar dados
    } catch (error) {
      console.error('Erro no check-in:', error)
    }
  }

  if (loading) {
    return <div className="flex justify-center items-center h-64">Carregando...</div>
  }

  if (!aula) {
    return <div className="text-center py-8">Aula não encontrada</div>
  }

  return (
    <div className="space-y-6">
      {/* Informações da Aula */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Clock className="w-5 h-5" />
            {aula.nome}
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-2">
          <p><strong>Professor:</strong> {aula.professor?.nome_completo}</p>
          <p><strong>Quadra:</strong> {aula.agendamento?.quadra?.nome}</p>
          <p><strong>Horário:</strong> {aula.hora_inicio} - {aula.hora_fim}</p>
          <p><strong>Data:</strong> {new Date(aula.data_aula).toLocaleDateString()}</p>
          <Badge variant={aula.status === 'confirmado' ? 'default' : 'secondary'}>
            {aula.status}
          </Badge>
        </CardContent>
      </Card>

      {/* Métodos de Check-in */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Button
          variant={checkInMethod === 'qr' ? 'default' : 'outline'}
          onClick={() => setCheckInMethod('qr')}
          className="h-20 flex-col"
        >
          <QrCode className="w-6 h-6 mb-2" />
          QR Code
        </Button>
        <Button
          variant={checkInMethod === 'geo' ? 'default' : 'outline'}
          onClick={() => setCheckInMethod('geo')}
          className="h-20 flex-col"
        >
          <MapPin className="w-6 h-6 mb-2" />
          Localização
        </Button>
        <Button
          variant={checkInMethod === 'manual' ? 'default' : 'outline'}
          onClick={() => setCheckInMethod('manual')}
          className="h-20 flex-col"
        >
          <User className="w-6 h-6 mb-2" />
          Manual
        </Button>
      </div>

      {/* Interface do Método Selecionado */}
      {checkInMethod === 'qr' && (
        <QRCodeGenerator aulaId={aulaId} onCheckIn={handleCheckIn} />
      )}
      
      {checkInMethod === 'geo' && (
        <GeolocationChecker aulaId={aulaId} onCheckIn={handleCheckIn} />
      )}
      
      {checkInMethod === 'manual' && (
        <ManualCheckIn aula={aula} onCheckIn={handleCheckIn} />
      )}
    </div>
  )
}
```

Implemente o sistema completo de aulas com check-in multi-método.
```

---

## PROMPT 9: TORNEIOS E EVENTOS

```
Desenvolva o sistema completo de gestão de torneios e eventos.

### PRIMEIRO PASSO - CRIAR TABELAS DE TORNEIOS:

#### 1. TABELA DE TORNEIOS:
```sql
CREATE TABLE torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  criado_por_id UUID REFERENCES usuarios(id),
  
  -- Dados básicos
  nome VARCHAR(150) NOT NULL,
  descricao TEXT,
  modalidade tipo_esporte NOT NULL,
  
  -- Datas importantes
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  data_limite_inscricao TIMESTAMPTZ NOT NULL,
  
  -- Configurações
  max_participantes INTEGER,
  max_duplas INTEGER,
  formato_chaveamento VARCHAR(50) DEFAULT 'eliminacao_simples',
  categoria_nivel nivel_jogo,
  categoria_idade_min INTEGER,
  categoria_idade_max INTEGER,
  
  -- Valores
  taxa_inscricao DECIMAL(8,2) NOT NULL DEFAULT 0,
  premiacao_total DECIMAL(8,2) DEFAULT 0,
  distribuicao_premiacao JSONB DEFAULT '{}',
  
  -- Status
  status VARCHAR(20) NOT NULL DEFAULT 'planejado',
  
  -- Regulamento
  regulamento TEXT,
  regras_especiais TEXT,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  CHECK (data_fim >= data_inicio),
  CHECK (data_limite_inscricao <= data_inicio),
  CHECK (taxa_inscricao >= 0)
);
```

#### 2. TABELA DE INSCRIÇÕES:
```sql
CREATE TABLE inscricoes_torneios (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  torneio_id UUID REFERENCES torneios(id) ON DELETE CASCADE,
  
  -- Participantes
  jogador1_id UUID REFERENCES usuarios(id) NOT NULL,
  jogador2_id UUID REFERENCES usuarios(id),
  
  -- Dados da inscrição
  data_inscricao TIMESTAMPTZ DEFAULT NOW(),
  valor_pago DECIMAL(8,2) DEFAULT 0,
  forma_pagamento forma_pagamento,
  
  -- Status
  status VARCHAR(20) NOT NULL DEFAULT 'inscrito',
  posicao_chaveamento INTEGER,
  
  -- Observações
  observacoes TEXT,
  necessidades_especiais TEXT,
  
  -- Metadados
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  UNIQUE(torneio_id, jogador1_id, jogador2_id)
);
```

### SEGUNDO PASSO - INTERFACE DE TORNEIOS:

#### 1. LISTA DE TORNEIOS:
```tsx
// app/(dashboard)/torneios/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Trophy, Users, Calendar, DollarSign, Plus } from 'lucide-react'
import { TorneioForm } from '@/components/torneios/TorneioForm'

interface Torneio {
  id: string
  nome: string
  modalidade: string
  data_inicio: string
  data_fim: string
  data_limite_inscricao: string
  max_participantes: number
  taxa_inscricao: number
  status: string
  inscricoes_count: number
}

export default function TorneiosPage() {
  const [torneios, setTorneios] = useState<Torneio[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)

  useEffect(() => {
    fetchTorneios()
  }, [])

  const fetchTorneios = async () => {
    try {
      const { data, error } = await supabase
        .from('torneios')
        .select(`
          *,
          inscricoes_count:inscricoes_torneios(count)
        `)
        .order('data_inicio', { ascending: false })

      if (error) throw error
      setTorneios(data || [])
    } catch (error) {
      console.error('Erro ao buscar torneios:', error)
    } finally {
      setLoading(false)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'planejado': return 'bg-blue-100 text-blue-800'
      case 'inscricoes_abertas': return 'bg-green-100 text-green-800'
      case 'em_andamento': return 'bg-yellow-100 text-yellow-800'
      case 'finalizado': return 'bg-gray-100 text-gray-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  const getStatusLabel = (status: string) => {
    const labels = {
      'planejado': 'Planejado',
      'inscricoes_abertas': 'Inscrições Abertas',
      'em_andamento': 'Em Andamento',
      'finalizado': 'Finalizado'
    }
    return labels[status] || status
  }

  if (loading) {
    return <div className="flex justify-center items-center h-64">Carregando...</div>
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Torneios</h1>
          <p className="text-gray-600">Organize e gerencie torneios da sua arena</p>
        </div>
        <Button onClick={() => setShowForm(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Novo Torneio
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {torneios.map((torneio) => (
          <Card key={torneio.id} className="hover:shadow-lg transition-shadow">
            <CardHeader className="pb-3">
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <CardTitle className="text-lg">{torneio.nome}</CardTitle>
                  <p className="text-sm text-gray-600 capitalize">
                    {torneio.modalidade.replace('_', ' ')}
                  </p>
                </div>
                <Badge className={getStatusColor(torneio.status)}>
                  {getStatusLabel(torneio.status)}
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-gray-400" />
                  <div>
                    <p className="font-medium">Início</p>
                    <p className="text-gray-600">
                      {new Date(torneio.data_inicio).toLocaleDateString()}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <Users className="w-4 h-4 text-gray-400" />
                  <div>
                    <p className="font-medium">Inscritos</p>
                    <p className="text-gray-600">
                      {torneio.inscricoes_count}/{torneio.max_participantes}
                    </p>
                  </div>
                </div>
              </div>

              <div className="flex items-center gap-2 text-sm">
                <DollarSign className="w-4 h-4 text-gray-400" />
                <div>
                  <p className="font-medium">Taxa de Inscrição</p>
                  <p className="text-gray-600">
                    R$ {torneio.taxa_inscricao.toFixed(2)}
                  </p>
                </div>
              </div>

              <div className="flex gap-2 pt-2">
                <Button size="sm" variant="outline" className="flex-1">
                  Ver Detalhes
                </Button>
                <Button size="sm" variant="outline">
                  Chaveamento
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {torneios.length === 0 && (
        <div className="text-center py-12">
          <Trophy className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">Nenhum torneio encontrado</h3>
          <p className="text-gray-600 mb-4">
            Comece organizando seu primeiro torneio
          </p>
          <Button onClick={() => setShowForm(true)}>
            <Plus className="w-4 h-4 mr-2" />
            Criar Primeiro Torneio
          </Button>
        </div>
      )}

      {showForm && (
        <TorneioForm
          onClose={() => setShowForm(false)}
          onSuccess={() => {
            setShowForm(false)
            fetchTorneios()
          }}
        />
      )}
    </div>
  )
}
```

Implemente o sistema completo de torneios com chaveamento automático.
```

---

## PROMPT 10: COMUNICAÇÃO E WHATSAPP

```
Desenvolva o sistema completo de comunicação integrado com WhatsApp.

### PRIMEIRO PASSO - CONFIGURAR EVOLUTION API:

#### 1. SERVIÇO WHATSAPP:
```typescript
// lib/services/whatsapp.ts
interface EvolutionConfig {
  baseURL: string
  apiKey: string
  instanceName: string
}

export class WhatsAppService {
  private config: EvolutionConfig

  constructor() {
    this.config = {
      baseURL: process.env.EVOLUTION_API_URL!,
      apiKey: process.env.EVOLUTION_API_KEY!,
      instanceName: process.env.EVOLUTION_INSTANCE_NAME!
    }
  }

  private async request(endpoint: string, options: RequestInit = {}) {
    const response = await fetch(`${this.config.baseURL}${endpoint}`, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        'apikey': this.config.apiKey,
        ...options.headers,
      },
    })

    if (!response.ok) {
      throw new Error(`WhatsApp API Error: ${response.statusText}`)
    }

    return response.json()
  }

  async sendMessage(to: string, message: string) {
    return this.request(`/message/sendText/${this.config.instanceName}`, {
      method: 'POST',
      body: JSON.stringify({
        number: to,
        text: message
      })
    })
  }

  async sendAgendamentoConfirmation(agendamento: any) {
    const message = `
🏐 *Agendamento Confirmado*

📅 Data: ${new Date(agendamento.data_agendamento).toLocaleDateString()}
⏰ Horário: ${agendamento.hora_inicio} - ${agendamento.hora_fim}
🏟️ Quadra: ${agendamento.quadra.nome}
💰 Valor: R$ ${agendamento.valor_total.toFixed(2)}

Para cancelar, responda CANCELAR
    `
    
    return this.sendMessage(agendamento.cliente.whatsapp, message)
  }

  async sendPaymentReminder(fatura: any) {
    const message = `
💰 *Lembrete de Pagamento*

Olá ${fatura.cliente.nome_completo}!

Sua mensalidade vence em ${new Date(fatura.data_vencimento).toLocaleDateString()}

💵 Valor: R$ ${fatura.valor_total.toFixed(2)}
📋 Fatura: ${fatura.numero_fatura}

Para pagar, acesse: ${fatura.asaas_invoice_url}
    `
    
    return this.sendMessage(fatura.cliente.whatsapp, message)
  }
}
```

### SEGUNDO PASSO - SISTEMA DE TEMPLATES:

#### 1. TABELA DE TEMPLATES:
```sql
CREATE TABLE templates_comunicacao (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  arena_id UUID REFERENCES arenas(id) ON DELETE CASCADE,
  nome VARCHAR(100) NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  canal VARCHAR(20) NOT NULL, -- whatsapp, email, sms
  assunto VARCHAR(200),
  conteudo TEXT NOT NULL,
  variaveis JSONB DEFAULT '[]',
  ativo BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. INTERFACE DE COMUNICAÇÃO:
```tsx
// app/(dashboard)/comunicacao/page.tsx
'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { MessageSquare, Mail, Phone, Send, Users } from 'lucide-react'
import { TemplateManager } from '@/components/comunicacao/TemplateManager'
import { CampanhaForm } from '@/components/comunicacao/CampanhaForm'

export default function ComunicacaoPage() {
  const [stats, setStats] = useState({
    mensagens_enviadas: 0,
    taxa_entrega: 0,
    taxa_abertura: 0,
    campanhas_ativas: 0
  })

  useEffect(() => {
    fetchStats()
  }, [])

  const fetchStats = async () => {
    // Implementar busca de estatísticas
    setStats({
      mensagens_enviadas: 1250,
      taxa_entrega: 98.5,
      taxa_abertura: 75.2,
      campanhas_ativas: 3
    })
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Comunicação</h1>
          <p className="text-gray-600">Gerencie a comunicação com seus clientes</p>
        </div>
        <Button>
          <Send className="w-4 h-4 mr-2" />
          Nova Campanha
        </Button>
      </div>

      {/* Cards de Estatísticas */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Mensagens Enviadas</CardTitle>
            <MessageSquare className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.mensagens_enviadas}</div>
            <p className="text-xs text-muted-foreground">
              +12% em relação ao mês anterior
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Taxa de Entrega</CardTitle>
            <Send className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.taxa_entrega}%</div>
            <p className="text-xs text-muted-foreground">
              Excelente taxa de entrega
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Taxa de Abertura</CardTitle>
            <Mail className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.taxa_abertura}%</div>
            <p className="text-xs text-muted-foreground">
              +5% em relação ao mês anterior
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Campanhas Ativas</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.campanhas_ativas}</div>
            <p className="text-xs text-muted-foreground">
              Campanhas em execução
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Tabs de Funcionalidades */}
      <Tabs defaultValue="templates" className="space-y-4">
        <TabsList>
          <TabsTrigger value="templates">Templates</TabsTrigger>
          <TabsTrigger value="campanhas">Campanhas</TabsTrigger>
          <TabsTrigger value="historico">Histórico</TabsTrigger>
          <TabsTrigger value="configuracoes">Configurações</TabsTrigger>
        </TabsList>

        <TabsContent value="templates">
          <TemplateManager />
        </TabsContent>

        <TabsContent value="campanhas">
          <CampanhaForm />
        </TabsContent>

        <TabsContent value="historico">
          <Card>
            <CardHeader>
              <CardTitle>Histórico de Comunicações</CardTitle>
            </CardHeader>
            <CardContent>
              <p>Histórico de mensagens enviadas...</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="configuracoes">
          <Card>
            <CardHeader>
              <CardTitle>Configurações de Comunicação</CardTitle>
            </CardHeader>
            <CardContent>
              <p>Configurações do WhatsApp, Email e SMS...</p>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  )
}
```

### TERCEIRO PASSO - AUTOMAÇÕES:

#### 1. WEBHOOK HANDLER:
```typescript
// app/api/webhooks/whatsapp/route.ts
import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase/server'

export async function POST(request: NextRequest) {
  try {
    const payload = await request.json()
    
    // Processar mensagem recebida
    if (payload.event === 'messages.upsert') {
      await handleIncomingMessage(payload.data)
    }
    
    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('WhatsApp webhook error:', error)
    return NextResponse.json({ error: 'Internal error' }, { status: 500 })
  }
}

async function handleIncomingMessage(messageData: any) {
  // Implementar lógica de resposta automática
  const message = messageData.message
  const from = messageData.key.remoteJid
  
  if (message.conversation?.toLowerCase().includes('cancelar')) {
    // Processar cancelamento
    await processarCancelamento(from)
  }
}
```

Implemente o sistema completo de comunicação com WhatsApp, templates e automações.
```

---

**Status:** ✅ Todos os 10 prompts completos disponíveis  
**Organização:** Prompts 0-7 no arquivo principal, 8-10 neste arquivo  
**Implementação:** Execute na ordem sequencial para melhor resultado