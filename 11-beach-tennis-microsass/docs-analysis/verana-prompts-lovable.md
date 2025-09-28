# VERANA BEACH TENNIS - PROMPTS COMPLETOS PARA LOVABLE

**Versão: 1.0.0**  
**Data: 27/09/2025**  
**Sistema: Multi-tenant White-label CRM/ERP para Arenas de Beach Tennis**

---

## ESTRUTURA DOS PROMPTS

### **ORGANIZAÇÃO:**
1. **Configuração Inicial** - Setup do projeto base
2. **Fase 1: MVP Core** - Funcionalidades essenciais
3. **Fase 2: Financeiro** - Integração Asaas e pagamentos
4. **Fase 3: Comunicação** - WhatsApp e notificações
5. **Fase 4: Aulas** - Gestão de aulas e check-ins
6. **Fase 5: Torneios** - Sistema de torneios
7. **Fase 6: Analytics** - Relatórios avançados

---

## PROMPT 1: CONFIGURAÇÃO INICIAL DO PROJETO

```
Crie um sistema completo de CRM/ERP para gestão de arenas de beach tennis, padel e tênis. 

ESPECIFICAÇÕES TÉCNICAS:
- Next.js 14 com App Router e TypeScript
- Supabase como backend (PostgreSQL + Auth + Storage)
- Tailwind CSS + Shadcn/UI para estilização
- Zustand para gerenciamento de estado
- React Query para data fetching
- React Hook Form + Zod para formulários
- Sistema multi-tenant com diferentes níveis de usuários

ARQUITETURA MULTI-TENANT:
1. Super Admin (você) - Controla todas as arenas
2. Admin Arena - Gestão completa da arena específica
3. Funcionários - Acesso limitado
4. Professores - Gestão de aulas
5. Alunos - App para agendamentos

ESTRUTURA DE PASTAS:
```
src/
├── app/
│   ├── (auth)/
│   ├── (dashboard)/
│   ├── (super-admin)/
│   └── api/
├── components/
│   ├── ui/ (Shadcn components)
│   ├── layout/
│   ├── forms/
│   └── common/
├── lib/
│   ├── supabase/
│   ├── validations/
│   ├── utils/
│   └── hooks/
├── store/
├── types/
└── styles/
```

CONFIGURAÇÕES INICIAIS:
1. Configure Supabase com autenticação
2. Implemente sistema de permissões hierárquico
3. Crie layout responsivo com sidebar colapsível
4. Configure dark/light mode
5. Implemente sistema de notificações toast

DESIGN SYSTEM:
- Cores: Primary #0066CC, Secondary #FF6B35
- Tipografia: Inter para textos
- Componentes: Use Shadcn/UI como base
- Responsivo: Mobile-first approach

Comece criando a estrutura base com autenticação e layout principal.
```

---

## PROMPT 2: SISTEMA DE AUTENTICAÇÃO E PERMISSÕES

```
Implemente um sistema completo de autenticação e permissões hierárquico.

FUNCIONALIDADES DE AUTENTICAÇÃO:
1. Login/logout com email e senha
2. Registro de novos usuários (apenas admins)
3. Recuperação de senha
4. Sessões persistentes
5. Middleware de proteção de rotas

NÍVEIS DE USUÁRIOS:
```typescript
enum UserRole {
  SUPER_ADMIN = 'super_admin',
  ARENA_ADMIN = 'arena_admin', 
  FUNCIONARIO = 'funcionario',
  PROFESSOR = 'professor',
  ALUNO = 'aluno'
}
```

SISTEMA DE PERMISSÕES:
```typescript
enum Permission {
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
  AGENDAMENTO_DELETE = 'agendamento:delete'
}
```

TELAS NECESSÁRIAS:
1. Login (/login)
2. Registro (/register) 
3. Esqueci senha (/forgot-password)
4. Primeira configuração (/setup)

HOOKS PERSONALIZADOS:
- useAuth() - Estado de autenticação
- usePermissions() - Verificação de permissões
- useUser() - Dados do usuário logado

MIDDLEWARE:
- Proteção de rotas por permissão
- Redirecionamento baseado no role
- Refresh automático de tokens

Implemente Row Level Security (RLS) no Supabase para isolar dados por arena.
```

---

## PROMPT 3: DASHBOARD PRINCIPAL E LAYOUT

```
Crie o dashboard principal com layout responsivo e sidebar dinâmica.

LAYOUT PRINCIPAL:
```
┌─ HEADER ─────────────────────────────────────────────────┐
│ [Logo] Arena Atual | Notificações | Perfil              │
├─────────────────────────────────────────────────────────┤
│ SIDEBAR │ MAIN CONTENT                                  │
│ [Menu]  │ - Breadcrumb                                  │
│         │ - Page Title + Actions                        │
│         │ - Content Area                                │
└─────────────────────────────────────────────────────────┘
```

COMPONENTES DO LAYOUT:
1. Header fixo com:
   - Logo e nome da arena atual
   - Seletor de arena (para super admin)
   - Notificações (badge + dropdown)
   - Menu do usuário (avatar + dropdown)

2. Sidebar colapsível com:
   - Menu de navegação hierárquico
   - Indicadores de status
   - Links condicionais por permissão

3. Main content com:
   - Breadcrumb navegacional
   - Page header com título e ações
   - Área de conteúdo flexível

DASHBOARD ADMIN ARENA:
Métricas em cards:
- Agendamentos hoje (número + % variação)
- Check-ins realizados
- Receita do dia (valor + % crescimento)
- Taxa de ocupação por quadra

Widgets interativos:
- Agenda do dia (próximos agendamentos)
- Alertas e notificações importantes
- Gráfico de ocupação semanal
- Lista de próximos vencimentos

DASHBOARD SUPER ADMIN:
Métricas consolidadas:
- Total de arenas ativas
- Receita mensal total
- Número de usuários
- Taxa de churn

Widgets específicos:
- Distribuição de arenas por plano
- Top 5 arenas por receita
- Arenas com problemas (vencidas, suporte)
- Módulos mais utilizados

RESPONSIVIDADE:
- Mobile: Sidebar vira drawer, cards empilhados
- Tablet: Layout híbrido
- Desktop: Layout completo

Use Recharts para gráficos e implemente skeleton loading states.
```

---

## PROMPT 4: GESTÃO DE ARENAS (MÓDULO 1)

```
Implemente o módulo completo de gestão de arenas.

FUNCIONALIDADES:

1. CRUD DE ARENAS:
```typescript
interface Arena {
  id: string
  tenant_id: string
  nome: string
  razao_social: string
  cnpj: string
  telefone: string
  whatsapp: string
  email: string
  endereco_completo: {
    cep: string
    rua: string
    numero: string
    bairro: string
    cidade: string
    uf: string
  }
  coordenadas?: { lat: number; lng: number }
  logo_url?: string
  cores_tema?: { primary: string; secondary: string }
  horario_funcionamento: {
    [key: string]: { abertura: string; fechamento: string; fechado: boolean }
  }
  status: 'ativo' | 'inativo' | 'suspenso'
  plano_id: string
  data_vencimento: string
}
```

2. FORMULÁRIO DE ARENA:
- Validação com Zod
- Upload de logo (Supabase Storage)
- Seletor de cores para tema
- Configuração de horários por dia da semana
- Integração com API de CEP (ViaCEP)
- Validação de CNPJ

3. CONFIGURAÇÕES DA ARENA:
Categorias de configuração:
- Agendamento (antecedência, cancelamento)
- Financeiro (formas de pagamento, juros)
- Comunicação (templates, canais)
- Geral (fuso horário, idioma)

4. POLÍTICAS DE NEGÓCIO:
```typescript
interface PoliticaNegocio {
  tipo_politica: 'cancelamento' | 'reposicao' | 'pagamento' | 'pontualidade'
  nome: string
  regras: {
    prazo_horas?: number
    percentual_multa?: number
    permite_reposicao?: boolean
    max_reposicoes?: number
  }
  descricao: string
  ativa: boolean
}
```

TELAS:
1. Lista de arenas (apenas super admin)
2. Perfil da arena atual
3. Configurações da arena
4. Políticas de negócio

VALIDAÇÕES:
- CNPJ válido e único
- Email único
- WhatsApp válido
- Horário de funcionamento consistente

Use React Hook Form + Zod para validações e toast notifications para feedback.
```

---

## PROMPT 5: GESTÃO DE QUADRAS (MÓDULO 2)

```
Desenvolva o sistema completo de gestão de quadras.

FUNCIONALIDADES:

1. CRUD DE QUADRAS:
```typescript
interface Quadra {
  id: string
  arena_id: string
  nome: string
  tipo_esporte: 'beach_tennis' | 'padel' | 'tenis'
  tipo_piso: 'areia' | 'saibro' | 'sintetico' | 'concreto'
  cobertura: boolean
  iluminacao: boolean
  dimensoes?: { largura: number; comprimento: number }
  capacidade_jogadores: number
  valor_hora_pico: number
  valor_hora_normal: number
  horarios_pico: {
    [dia: string]: Array<{ inicio: string; fim: string }>
  }
  equipamentos_inclusos: string[]
  status: 'ativa' | 'manutencao' | 'inativa'
  observacoes?: string
}
```

2. SISTEMA DE BLOQUEIOS:
```typescript
interface QuadraBloqueio {
  id: string
  quadra_id: string
  tipo_bloqueio: 'manutencao' | 'evento' | 'clima' | 'outro'
  data_inicio: string
  data_fim: string
  motivo: string
  observacoes?: string
  status: 'ativo' | 'cancelado' | 'finalizado'
}
```

3. HISTÓRICO DE MANUTENÇÕES:
```typescript
interface Manutencao {
  tipo_manutencao: 'preventiva' | 'corretiva' | 'emergencial'
  data_manutencao: string
  descricao: string
  fornecedor?: string
  valor_gasto?: number
  tempo_parada?: number
  anexos?: string[]
  proximo_agendamento?: string
}
```

4. EQUIPAMENTOS POR QUADRA:
Lista de equipamentos com controle de estado e vida útil.

TELAS:
1. Lista de quadras com status visual
2. Formulário de cadastro/edição
3. Agenda da quadra (timeline de uso)
4. Histórico de manutenções
5. Modal de bloqueio rápido

FUNCIONALIDADES ESPECIAIS:
- Cálculo automático de ocupação
- Sugestão de horários livres
- Alertas de manutenção preventiva
- Reagendamento automático em bloqueios
- Dashboard de performance por quadra

VALIDAÇÕES:
- Conflito de horários em bloqueios
- Valores coerentes (pico >= normal)
- Capacidade válida por modalidade

Use FullCalendar para visualização da agenda e implement drag-and-drop para reagendamentos.
```

---

## PROMPT 6: GESTÃO DE PESSOAS (MÓDULO 3)

```
Crie o sistema completo de gestão de pessoas (alunos, professores, funcionários).

FUNCIONALIDADES:

1. CRUD DE USUÁRIOS:
```typescript
interface Usuario {
  id: string
  arena_id: string
  tipo_usuario: 'aluno' | 'professor' | 'funcionario' | 'admin'
  nome_completo: string
  email: string
  telefone: string
  whatsapp?: string
  cpf: string
  data_nascimento: string
  genero?: 'masculino' | 'feminino' | 'outro'
  endereco?: EnderecoCompleto
  nivel_jogo?: 'iniciante' | 'intermediario' | 'avancado' | 'profissional'
  dominancia?: 'destro' | 'canhoto' | 'ambidestro'
  posicao_preferida?: 'rede' | 'fundo' | 'ambas'
  observacoes_medicas?: string
  contato_emergencia?: { nome: string; telefone: string }
  foto_url?: string
  status: 'ativo' | 'inativo' | 'suspenso'
}
```

2. DADOS ESPECÍFICOS DE PROFESSORES:
```typescript
interface Professor {
  usuario_id: string
  registro_profissional?: string
  especialidades: string[]
  valor_hora_aula: number
  percentual_comissao?: number
  disponibilidade: {
    [dia: string]: Array<{ inicio: string; fim: string }>
  }
  biografia?: string
  certificacoes?: string[]
  experiencia_anos?: number
  status_professor: 'ativo' | 'inativo' | 'licenca'
}
```

3. HISTÓRICO DE ATIVIDADES:
Track completo de ações dos usuários:
- Agendamentos realizados
- Aulas assistidas
- Pagamentos efetuados
- Cancelamentos

4. AVALIAÇÕES DE PERFORMANCE:
Sistema de avaliação para professores e evolução de alunos.

5. EVOLUÇÃO DOS ALUNOS:
```typescript
interface EvolucaoAluno {
  aluno_id: string
  professor_id: string
  data_avaliacao: string
  nivel_anterior?: string
  nivel_atual: string
  habilidades_desenvolvidas: string[]
  areas_melhorar?: string[]
  observacoes?: string
  proximos_objetivos?: string
}
```

TELAS:
1. Lista de pessoas (com filtros por tipo)
2. Perfil detalhado da pessoa
3. Formulário de cadastro/edição
4. Histórico de atividades
5. Avaliações e evolução
6. Importação em massa (CSV)

FUNCIONALIDADES AVANÇADAS:
- Busca inteligente (nome, CPF, telefone)
- Agrupamento por nível/modalidade
- Geração de relatórios de performance
- Sistema de tags personalizadas
- Comunicação em massa por segmento

VALIDAÇÕES:
- CPF único e válido
- Email único por arena
- Telefone brasileiro válido
- Data de nascimento consistente

COMPONENTES ESPECIAIS:
- Seletor de foto com crop
- Formulário de endereço com CEP
- Timeline de atividades
- Gráficos de evolução

Use React Table para listagem avançada e implement upload de imagem com preview.
```

---

## PROMPT 7: SISTEMA DE AGENDAMENTOS (MÓDULO 4)

```
Desenvolva o sistema completo de agendamentos com check-in inteligente.

FUNCIONALIDADES PRINCIPAIS:

1. CRUD DE AGENDAMENTOS:
```typescript
interface Agendamento {
  id: string
  arena_id: string
  quadra_id: string
  cliente_id: string
  tipo_agendamento: 'avulso' | 'aula' | 'torneio' | 'evento'
  data_agendamento: string
  hora_inicio: string
  hora_fim: string
  valor_total: number
  valor_pago?: number
  status_pagamento: 'pendente' | 'pago' | 'parcial' | 'cancelado'
  forma_pagamento?: string
  participantes?: string[]
  equipamentos_solicitados?: string[]
  status_agendamento: 'confirmado' | 'pendente' | 'cancelado' | 'realizado'
  observacoes?: string
}
```

2. SISTEMA DE CHECK-IN:
```typescript
interface CheckIn {
  id: string
  agendamento_id: string
  usuario_id: string
  tipo_checkin: 'qrcode' | 'geolocalizacao' | 'manual' | 'biometria'
  data_checkin: string
  localizacao?: { lat: number; lng: number }
  dispositivo_info?: any
  responsavel_checkin?: string
  status: 'presente' | 'ausente' | 'atrasado'
}
```

3. LISTA DE ESPERA:
```typescript
interface ListaEspera {
  id: string
  arena_id: string
  quadra_id: string
  cliente_id: string
  data_desejada: string
  hora_inicio_desejada: string
  hora_fim_desejada: string
  flexibilidade_horario?: any
  prioridade: number
  aceite_automatico: boolean
  status: 'aguardando' | 'notificado' | 'atendido' | 'expirado'
}
```

4. AGENDAMENTOS RECORRENTES:
Sistema para agendamentos repetidos (semanal, quinzenal, mensal).

TELAS PRINCIPAIS:
1. Dashboard de agendamentos (hoje/semana/mês)
2. Calendário visual com drag-and-drop
3. Timeline do dia por quadra
4. Formulário de novo agendamento (wizard)
5. Modal de check-in com QR Code
6. Lista de espera
7. Agendamentos recorrentes

FUNCIONALIDADES AVANÇADAS:

1. WIZARD DE AGENDAMENTO:
- Passo 1: Selecionar data/hora
- Passo 2: Escolher quadra disponível
- Passo 3: Adicionar participantes
- Passo 4: Configurar pagamento
- Passo 5: Confirmar reserva

2. SISTEMA DE CHECK-IN:
- QR Code único por agendamento
- Geolocalização automática
- Check-in manual pelo staff
- Notificações de lembrete

3. GESTÃO DE CONFLITOS:
- Verificação automática de disponibilidade
- Sugestões de horários alternativos
- Reagendamento inteligente

4. NOTIFICAÇÕES AUTOMÁTICAS:
- Confirmação de agendamento
- Lembrete 24h antes
- Lembrete 1h antes
- Check-in bem-sucedido

VALIDAÇÕES:
- Conflito de horários
- Horário dentro do funcionamento
- Capacidade da quadra
- Status da quadra (ativa)

COMPONENTES ESPECIAIS:
- Calendário interativo (FullCalendar)
- QR Code generator/reader
- Geolocalização (navigator.geolocation)
- Timeline de agendamentos
- Busca de horários livres

Use React QR Code para geração de códigos e implement real-time updates com Supabase subscriptions.
```

---

## PROMPT 8: GESTÃO FINANCEIRA (MÓDULO 6)

```
Implemente o sistema completo de gestão financeira com integração Asaas.

FUNCIONALIDADES PRINCIPAIS:

1. PLANOS E CONTRATOS:
```typescript
interface Plano {
  id: string
  arena_id: string
  nome: string
  tipo_plano: 'mensal' | 'trimestral' | 'semestral' | 'anual'
  valor: number
  beneficios: string[]
  limitacoes?: string[]
  status: 'ativo' | 'inativo'
}

interface Contrato {
  id: string
  arena_id: string
  cliente_id: string
  plano_id: string
  data_inicio: string
  data_fim?: string
  valor_mensal: number
  dia_vencimento: number
  forma_pagamento: 'cartao_recorrente' | 'boleto' | 'pix'
  dados_pagamento?: any
  status: 'ativo' | 'suspenso' | 'cancelado' | 'inadimplente'
}
```

2. SISTEMA DE FATURAS:
```typescript
interface Fatura {
  id: string
  arena_id: string
  cliente_id: string
  contrato_id?: string
  numero_fatura: string
  data_vencimento: string
  valor_original: number
  valor_desconto?: number
  valor_acrescimo?: number
  valor_final: number
  status: 'pendente' | 'paga' | 'vencida' | 'cancelada'
  asaas_payment_id?: string
}
```

3. COMISSÕES DE PROFESSORES:
```typescript
interface ComissaoProfessor {
  id: string
  professor_id: string
  periodo_inicio: string
  periodo_fim: string
  total_aulas: number
  valor_total_aulas: number
  percentual_comissao: number
  valor_comissao: number
  descontos?: number
  valor_liquido: number
  status: 'calculada' | 'paga' | 'cancelada'
}
```

TELAS PRINCIPAIS:
1. Dashboard financeiro (KPIs + gráficos)
2. Lista de faturas (com filtros avançados)
3. Gestão de planos e contratos
4. Comissões de professores
5. Movimentações financeiras
6. Relatórios de inadimplência
7. Configuração de formas de pagamento

INTEGRAÇÃO ASAAS:

1. CONFIGURAÇÃO:
```typescript
class AsaasService {
  private baseURL: string
  private apiKey: string

  async createCustomer(data: any): Promise<any>
  async createPayment(data: any): Promise<any>
  async getPayment(id: string): Promise<any>
  async cancelPayment(id: string): Promise<any>
}
```

2. WEBHOOK HANDLER:
```typescript
// app/api/webhooks/asaas/route.ts
export async function POST(request: Request) {
  const payload = await request.json()
  
  switch (payload.event) {
    case 'PAYMENT_CONFIRMED':
      await handlePaymentConfirmed(payload)
      break
    case 'PAYMENT_OVERDUE':
      await handlePaymentOverdue(payload)
      break
  }
}
```

FUNCIONALIDADES AVANÇADAS:

1. COBRANÇA AUTOMÁTICA:
- Geração automática de faturas
- Envio de cobrança por email/WhatsApp
- Retry automático para cartões

2. CONTROLE DE INADIMPLÊNCIA:
- Relatório de vencidos
- Ações automáticas (suspensão)
- Negociação de débitos

3. RELATÓRIOS FINANCEIROS:
- Receita por modalidade
- Fluxo de caixa
- DRE simplificado
- Comparativos mensais

4. DASHBOARD FINANCEIRO:
- Métricas principais em cards
- Gráfico de receita (linha)
- Distribuição por forma de pagamento (pizza)
- Lista de próximos vencimentos

VALIDAÇÕES:
- Valor mínimo para cobranças
- Datas de vencimento válidas
- Status consistentes
- Cálculos de comissão corretos

Use Recharts para gráficos financeiros e implement real-time updates para status de pagamentos.
```

---

## PROMPT 9: GESTÃO DE AULAS (MÓDULO 5)

```
Desenvolva o sistema completo de gestão de aulas com reposições automáticas.

FUNCIONALIDADES PRINCIPAIS:

1. TIPOS DE AULA:
```typescript
interface TipoAula {
  id: string
  arena_id: string
  nome: string
  modalidade: 'beach_tennis' | 'padel' | 'tenis'
  nivel_exigido: 'iniciante' | 'intermediario' | 'avancado'
  max_alunos: number
  duracao_minutos: number
  valor_aula: number
  descricao?: string
  equipamentos_necessarios?: string[]
  status: 'ativo' | 'inativo'
}
```

2. AULAS AGENDADAS:
```typescript
interface Aula {
  id: string
  arena_id: string
  tipo_aula_id: string
  professor_id: string
  quadra_id: string
  data_aula: string
  hora_inicio: string
  hora_fim: string
  max_alunos: number
  valor_total: number
  observacoes?: string
  material_aula?: string
  status: 'agendada' | 'realizada' | 'cancelada'
}
```

3. MATRÍCULAS:
```typescript
interface MatriculaAula {
  id: string
  aula_id: string
  aluno_id: string
  data_matricula: string
  valor_pago: number
  status_pagamento: 'pendente' | 'pago' | 'cancelado'
  presente?: boolean
  data_checkin?: string
  avaliacao_aula?: number
  feedback_aluno?: string
  status: 'ativa' | 'cancelada' | 'transferida'
}
```

4. SISTEMA DE REPOSIÇÕES:
```typescript
interface Reposicao {
  id: string
  matricula_original_id: string
  aula_nova_id?: string
  motivo_reposicao: 'falta_aluno' | 'falta_professor' | 'clima' | 'outro'
  data_solicitacao: string
  prazo_limite: string
  observacoes?: string
  status: 'pendente' | 'agendada' | 'utilizada' | 'expirada'
}
```

5. PLANOS DE AULA:
```typescript
interface PlanoAula {
  id: string
  professor_id: string
  tipo_aula_id: string
  titulo: string
  objetivos: string[]
  aquecimento?: string
  parte_principal: string
  exercicios: any[]
  materiais_necessarios?: string[]
  dificuldade: 'iniciante' | 'intermediario' | 'avancado'
  duracao_estimada: number
}
```

6. PACOTES DE AULAS:
```typescript
interface PacoteAulas {
  id: string
  arena_id: string
  nome_pacote: string
  tipo_aula_id: string
  quantidade_aulas: number
  valor_total: number
  valor_por_aula: number
  desconto_percentual?: number
  validade_dias: number
  transferivel: boolean
  reembolsavel: boolean
}
```

TELAS PRINCIPAIS:
1. Agenda de aulas (professor e arena)
2. Lista de tipos de aula
3. Matrículas e check-ins
4. Gestão de reposições
5. Planos de aula
6. Pacotes disponíveis
7. Relatório de presença

FUNCIONALIDADES AVANÇADAS:

1. CHECK-IN DE AULAS:
- Lista de alunos matriculados
- Check-in rápido por nome
- Controle de atrasos
- Geração automática de reposições para faltas

2. SISTEMA DE REPOSIÇÕES:
- Criação automática para no-shows
- Políticas configuráveis por arena
- Prazo de validade personalizável
- Notificações de expiração

3. GESTÃO DE PRESENÇA:
- Relatório de frequência por aluno
- Identificação de alunos com baixa presença
- Alertas para professores

4. AVALIAÇÃO DE AULAS:
- Feedback dos alunos
- Avaliação do professor
- Evolução do desempenho

COMPONENTES ESPECIAIS:
- Calendário de aulas (semanal/mensal)
- Lista de presença interativa
- Timeline de evolução do aluno
- Builder de planos de aula

VALIDAÇÕES:
- Capacidade máxima da aula
- Conflito de horários do professor
- Disponibilidade da quadra
- Nível adequado do aluno

AUTOMAÇÕES:
- Criação de reposições para faltas
- Notificações de aulas próximas
- Cálculo automático de comissões
- Alertas de baixa frequência

Use React DnD para drag-and-drop de alunos entre aulas e implement real-time check-in updates.
```

---

## PROMPT 10: SISTEMA DE TORNEIOS (MÓDULO 7)

```
Crie o sistema completo de torneios com chaveamento automático.

FUNCIONALIDADES PRINCIPAIS:

1. GESTÃO DE TORNEIOS:
```typescript
interface Torneio {
  id: string
  arena_id: string
  nome: string
  modalidade: 'beach_tennis' | 'padel' | 'tenis'
  categoria: 'iniciante' | 'intermediario' | 'avancado' | 'mista'
  tipo_disputa: 'simples' | 'duplas' | 'mista'
  data_inicio: string
  data_fim: string
  data_limite_inscricao: string
  max_participantes: number
  valor_inscricao: number
  premiacao?: any
  regulamento: string
  status: 'inscricoes_abertas' | 'em_andamento' | 'finalizado' | 'cancelado'
}
```

2. INSCRIÇÕES:
```typescript
interface InscricaoTorneio {
  id: string
  torneio_id: string
  jogador1_id: string
  jogador2_id?: string // Para duplas
  data_inscricao: string
  valor_pago: number
  status_pagamento: 'pendente' | 'pago' | 'cancelado'
  status: 'confirmada' | 'pendente' | 'cancelada'
}
```

3. CHAVEAMENTO:
```typescript
interface Chaveamento {
  id: string
  torneio_id: string
  tipo_chave: 'eliminatoria_simples' | 'eliminatoria_dupla' | 'round_robin'
  estrutura_chave: any
  data_sorteio: string
  criterio_sorteio: 'aleatorio' | 'ranking' | 'seed'
  status: 'gerada' | 'em_andamento' | 'finalizada'
}
```

4. PARTIDAS:
```typescript
interface PartidaTorneio {
  id: string
  torneio_id: string
  chaveamento_id: string
  fase: 'primeira_fase' | 'oitavas' | 'quartas' | 'semi' | 'final'
  rodada: number
  inscricao1_id: string
  inscricao2_id?: string
  quadra_id?: string
  data_agendada?: string
  data_realizada?: string
  placar?: any
  inscricao_vencedora_id?: string
  status: 'agendada' | 'em_andamento' | 'finalizada' | 'cancelada'
}
```

5. RESULTADOS:
```typescript
interface ResultadoTorneio {
  id: string
  torneio_id: string
  inscricao_id: string
  posicao_final: number
  pontos_conquistados?: number
  premiacao_recebida?: number
  partidas_jogadas: number
  vitorias: number
  derrotas: number
}
```

6. EVENTOS ESPECIAIS:
```typescript
interface Evento {
  id: string
  arena_id: string
  nome_evento: string
  tipo_evento: 'clinica' | 'workshop' | 'amistoso' | 'confraternizacao'
  data_evento: string
  hora_inicio: string
  hora_fim: string
  max_participantes?: number
  valor_inscricao?: number
  descricao: string
  responsavel_id?: string
  status: 'planejado' | 'confirmado' | 'realizado' | 'cancelado'
}
```

TELAS PRINCIPAIS:
1. Lista de torneios
2. Detalhes do torneio (inscrições abertas)
3. Chaveamento visual
4. Painel de controle do torneio
5. Resultados e classificação
6. Eventos especiais
7. Histórico de torneios

FUNCIONALIDADES AVANÇADAS:

1. CHAVEAMENTO AUTOMÁTICO:
- Geração baseada no número de participantes
- Suporte a eliminatória simples/dupla
- Sistema de byes automático
- Sorteio com seeds

2. GESTÃO DE PARTIDAS:
- Agendamento automático
- Controle de resultados
- Avanço automático nas fases
- Geração de próximas partidas

3. INSCRIÇÕES:
- Formulário público de inscrição
- Validação de categorias
- Pagamento online
- Lista de espera

4. COMUNICAÇÃO:
- Notificações por fase
- Resultados em tempo real
- Convocações para partidas
- Divulgação de resultados

COMPONENTES ESPECIAIS:

1. BRACKET VISUAL:
```typescript
// Componente de chaveamento visual
const TournamentBracket = ({ torneio, partidas }) => {
  // Renderização visual da chave
  // Drag-and-drop para reagendamento
  // Updates em tempo real
}
```

2. SISTEMA DE PONTUAÇÃO:
- Placar interativo
- Validação de sets/games
- Cálculo automático do vencedor

3. PREMIAÇÃO:
- Configuração flexível de prêmios
- Distribuição automática
- Controle de entrega

VALIDAÇÕES:
- Número de participantes válido
- Datas consistentes
- Capacidade das quadras
- Formação de duplas válida

AUTOMAÇÕES:
- Criação de partidas por fase
- Notificações de convocação
- Avanço automático de vencedores
- Geração de certificados

Use D3.js ou similar para visualização do bracket e implement WebSocket para updates em tempo real.
```

---

## PROMPT 11: SISTEMA DE RELATÓRIOS (MÓDULO 8)

```
Desenvolva o sistema completo de relatórios e analytics com configuração de visibilidade.

FUNCIONALIDADES PRINCIPAIS:

1. CONFIGURAÇÃO DE VISIBILIDADE:
```typescript
interface ConfiguracaoVisibilidade {
  id: string
  arena_id: string
  tipo_usuario: 'professor' | 'aluno' | 'funcionario'
  secao_relatorio: 'performance' | 'financeiro' | 'frequencia' | 'ranking'
  visivel: boolean
  nivel_detalhe: 'basico' | 'completo' | 'detalhado'
  campos_bloqueados?: string[]
}
```

2. RELATÓRIOS PERSONALIZADOS:
```typescript
interface RelatorioPersonalizado {
  id: string
  arena_id: string
  nome_relatorio: string
  tipo_relatorio: 'ocupacao' | 'financeiro' | 'frequencia' | 'performance'
  filtros: any
  colunas_visiveis: string[]
  periodo_padrao: 'hoje' | 'semana' | 'mes' | 'trimestre' | 'ano'
  frequencia_envio?: 'diario' | 'semanal' | 'mensal'
  emails_destinatarios?: string[]
  visivel_para: string[]
}
```

DASHBOARDS POR TIPO DE USUÁRIO:

1. SUPER ADMIN (Consolidado):
- Métricas globais de todas as arenas
- Ranking de arenas por receita
- Distribuição por planos
- Churn rate e crescimento
- Módulos mais utilizados

2. ADMIN ARENA:
- Dashboard operacional da arena
- Métricas financeiras
- Ocupação de quadras
- Performance da equipe
- Relatórios customizáveis

3. PROFESSORES:
- Performance individual
- Evolução dos alunos
- Comissões recebidas
- Agenda e frequência
- Comparativos (se liberado)

4. ALUNOS:
- Histórico pessoal
- Evolução e progresso
- Gastos e pagamentos
- Ranking interno (se liberado)
- Estatísticas de jogo

TIPOS DE RELATÓRIOS:

1. OPERACIONAIS:
```typescript
interface RelatorioOcupacao {
  quadra_id: string
  periodo: string
  total_horas_disponiveis: number
  total_horas_ocupadas: number
  taxa_ocupacao: number
  receita_gerada: number
  picos_demanda: any[]
}
```

2. FINANCEIROS:
```typescript
interface RelatorioFinanceiro {
  periodo: string
  receita_total: number
  receita_por_categoria: any
  despesas_total: number
  lucro_liquido: number
  inadimplencia: number
  crescimento_percentual: number
}
```

3. PERFORMANCE:
```typescript
interface RelatorioPerformance {
  usuario_id: string
  periodo: string
  aulas_ministradas?: number
  presenca_percentual?: number
  avaliacao_media?: number
  evolucao_nivel?: string
  comissoes_recebidas?: number
}
```

TELAS PRINCIPAIS:
1. Dashboard principal (por tipo de usuário)
2. Builder de relatórios
3. Configuração de visibilidade
4. Agenda de relatórios
5. Histórico de execuções
6. Exportação de dados

FUNCIONALIDADES AVANÇADAS:

1. BUILDER DE RELATÓRIOS:
- Interface drag-and-drop
- Filtros dinâmicos
- Visualizações customizáveis
- Agendamento automático

2. SISTEMA DE PERMISSÕES:
- Controle granular por seção
- Níveis de detalhe configuráveis
- Mascaramento de dados sensíveis

3. EXPORTAÇÃO:
- PDF com charts
- Excel com múltiplas abas
- CSV para análises
- API para integrações

4. ALERTAS INTELIGENTES:
- Métricas fora do padrão
- Tendências negativas
- Oportunidades de melhoria

COMPONENTES ESPECIAIS:

1. CHART COMPONENTS:
```typescript
const RevenueChart = ({ data, period }) => {
  // Gráfico de receita com Recharts
  // Drill-down por categoria
  // Comparativo de períodos
}

const OccupancyHeatmap = ({ data }) => {
  // Mapa de calor de ocupação
  // Por horário e dia da semana
  // Identificação de padrões
}
```

2. DASHBOARD WIDGETS:
- Cards de métricas responsivos
- Mini-gráficos embarcados
- Indicadores de tendência
- Ações rápidas

3. FILTROS AVANÇADOS:
- Date range picker
- Multi-select com search
- Filtros salvos
- Aplicação em tempo real

VALIDAÇÕES:
- Períodos válidos
- Permissões de visualização
- Dados sensíveis mascarados
- Performance de consultas

OTIMIZAÇÕES:
- Cache de relatórios pesados
- Paginação para grandes datasets
- Lazy loading de charts
- Compressão de dados

Use Recharts para visualizações, jsPDF para exports e implement virtual scrolling para grandes listas.
```

---

## PROMPT 12: NOTIFICAÇÕES E COMUNICAÇÃO (MÓDULO 11)

```
Implemente o sistema completo de notificações e comunicação.

FUNCIONALIDADES PRINCIPAIS:

1. CENTRAL DE NOTIFICAÇÕES:
```typescript
interface Notificacao {
  id: string
  arena_id: string
  usuario_destinatario_id: string
  tipo_notificacao: 'sistema' | 'agendamento' | 'pagamento' | 'promocao'
  titulo: string
  mensagem: string
  dados_extras?: any
  canal_envio: 'app' | 'email' | 'whatsapp' | 'sms'
  prioridade: 'baixa' | 'media' | 'alta' | 'urgente'
  agendada_para?: string
  enviada_em?: string
  lida_em?: string
  acao_executada: boolean
  status: 'pendente' | 'enviada' | 'lida' | 'erro'
}
```

2. CAMPANHAS DE MARKETING:
```typescript
interface Campanha {
  id: string
  arena_id: string
  nome_campanha: string
  tipo_campanha: 'promocional' | 'retencao' | 'aniversario' | 'reativacao'
  publico_alvo: any
  canais_envio: string[]
  conteudo_mensagem: string
  data_inicio: string
  data_fim?: string
  total_destinatarios: number
  enviados: number
  abertos: number
  cliques: number
  conversoes: number
  status: 'rascunho' | 'agendada' | 'enviando' | 'concluida'
}
```

3. TEMPLATES DE COMUNICAÇÃO:
```typescript
interface TemplateComunicacao {
  id: string
  arena_id: string
  nome_template: string
  tipo_template: 'confirmacao' | 'lembrete' | 'cancelamento' | 'promocao'
  canal: 'email' | 'whatsapp' | 'sms' | 'push'
  assunto?: string
  conteudo: string
  variaveis: string[]
  ativo: boolean
}
```

4. HISTÓRICO DE COMUNICAÇÕES:
```typescript
interface HistoricoComunicacao {
  id: string
  arena_id: string
  usuario_id: string
  tipo_comunicacao: 'whatsapp' | 'email' | 'sms' | 'push' | 'ligacao'
  assunto: string
  conteudo: string
  remetente: string
  data_envio: string
  data_entrega?: string
  data_leitura?: string
  status_entrega: 'enviado' | 'entregue' | 'lido' | 'erro'
  anexos?: string[]
}
```

TELAS PRINCIPAIS:
1. Central de notificações (inbox)
2. Criador de campanhas
3. Gerenciador de templates
4. Histórico de comunicações
5. Configurações de notificação
6. Analytics de campanhas

TIPOS DE NOTIFICAÇÃO:

1. AUTOMÁTICAS:
- Confirmação de agendamento
- Lembrete 24h antes
- Check-in bem-sucedido
- Pagamento confirmado
- Vencimento próximo

2. MANUAIS:
- Mensagens promocionais
- Avisos importantes
- Comunicados da arena
- Felicitações personalizadas

3. SISTEMA:
- Falhas de pagamento
- Manutenções programadas
- Updates do sistema
- Alertas de segurança

CANAIS DE COMUNICAÇÃO:

1. IN-APP:
- Toast notifications
- Badge no ícone
- Central de notificações
- Pop-ups importantes

2. EMAIL:
```typescript
interface EmailService {
  sendTemplate(to: string, templateId: string, variables: any): Promise<void>
  sendCampaign(campaign: Campanha): Promise<void>
  trackOpens(emailId: string): void
  trackClicks(emailId: string, linkId: string): void
}
```

3. WHATSAPP:
```typescript
interface WhatsAppService {
  sendMessage(to: string, message: string): Promise<void>
  sendTemplate(to: string, template: string, params: any[]): Promise<void>
  sendMedia(to: string, mediaUrl: string, caption?: string): Promise<void>
}
```

4. PUSH NOTIFICATIONS:
```typescript
interface PushService {
  sendToUser(userId: string, notification: any): Promise<void>
  sendToSegment(segment: any, notification: any): Promise<void>
  scheduleNotification(notification: any, date: string): Promise<void>
}
```

FUNCIONALIDADES AVANÇADAS:

1. SEGMENTAÇÃO DE PÚBLICO:
- Por nível de jogo
- Por frequência de uso
- Por valor gasto
- Por localização
- Por preferências

2. PERSONALIZAÇÃO:
- Variáveis dinâmicas
- Conteúdo condicional
- Horário otimizado
- Frequência controlada

3. ANALYTICS:
- Taxa de abertura
- Taxa de clique
- Conversões
- ROI das campanhas
- A/B testing

4. AUTOMAÇÃO:
- Triggered campaigns
- Drip campaigns
- Behavioral triggers
- Lifecycle marketing

COMPONENTES ESPECIAIS:

1. EDITOR DE TEMPLATES:
```typescript
const TemplateEditor = ({ template, variables }) => {
  // Editor WYSIWYG
  // Preview com variáveis
  // Validação de sintaxe
  // Teste de envio
}
```

2. CAMPAIGN BUILDER:
```typescript
const CampaignBuilder = () => {
  // Wizard de criação
  // Seletor de público
  // Preview multicanal
  // Agendamento
}
```

3. NOTIFICATION CENTER:
```typescript
const NotificationCenter = ({ notifications }) => {
  // Lista agrupada por tipo
  // Marcar como lida
  // Ações rápidas
  // Filtros
}
```

INTEGRAÇÕES:

1. RESEND (Email):
- Templates profissionais
- Tracking de abertura/clique
- Bounce handling
- Reputation management

2. TWILIO (SMS):
- Envio internacional
- Status de entrega
- Two-way messaging
- Short codes

3. EVOLUTION API (WhatsApp):
- Business API
- Templates aprovados
- Webhook handling
- Media support

VALIDAÇÕES:
- Consentimento LGPD
- Limites de envio
- Blacklist management
- Spam prevention

Use React Email para templates e implement WebSocket para notificações real-time.
```

---

## PROMPT 13: CONFIGURAÇÕES E INTEGRAÇÕES (MÓDULO 9)

```
Desenvolva o sistema completo de configurações e integrações externas.

FUNCIONALIDADES PRINCIPAIS:

1. CONTROLE DE MÓDULOS (Super Admin):
```typescript
interface ModuloArena {
  id: string
  arena_id: string
  modulo_nome: 'agendamentos' | 'aulas' | 'financeiro' | 'torneios' | 'whatsapp'
  ativo: boolean
  data_ativacao?: string
  data_desativacao?: string
  motivo_desativacao?: string
  configurado_por: string
}
```

2. CONFIGURAÇÕES GERAIS:
```typescript
interface Configuracao {
  id: string
  arena_id: string
  categoria: 'agendamento' | 'financeiro' | 'comunicacao' | 'geral' | 'seguranca'
  chave: string
  valor: any
  tipo_campo: 'texto' | 'numero' | 'boolean' | 'lista' | 'json'
  descricao?: string
  editavel: boolean
  visivel_admin: boolean
}
```

3. INTEGRAÇÃO WHATSAPP:
```typescript
interface IntegracaoWhatsApp {
  id: string
  arena_id: string
  api_key: string
  webhook_url: string
  numero_whatsapp: string
  nome_instancia: string
  status_conexao: 'conectado' | 'desconectado' | 'erro'
  ultimo_teste?: string
  templates_configurados?: any
  ativo: boolean
}
```

4. INTEGRAÇÃO ASAAS:
```typescript
interface IntegracaoAsaas {
  id: string
  arena_id: string
  api_key: string
  webhook_url: string
  ambiente: 'sandbox' | 'producao'
  status_conexao: 'conectado' | 'desconectado' | 'erro'
  ultimo_teste?: string
  configuracoes_cobranca: any
  taxa_personalizada?: number
  ativo: boolean
}
```

5. AUTOMAÇÕES N8N:
```typescript
interface AutomacaoN8N {
  id: string
  arena_id: string
  nome_automacao: string
  tipo_trigger: 'novo_usuario' | 'pagamento_vencido' | 'lembrete_aula'
  webhook_url: string
  workflow_id?: string
  parametros?: any
  ultima_execucao?: string
  total_execucoes: number
  ativo: boolean
}
```

TELAS PRINCIPAIS:
1. Configurações gerais da arena
2. Módulos ativos (super admin)
3. Integrações (WhatsApp, Asaas, N8N)
4. Templates de comunicação
5. Backup e segurança
6. Logs de sistema
7. Configurações de usuário

CONFIGURAÇÕES POR CATEGORIA:

1. AGENDAMENTO:
- Antecedência máxima/mínima
- Horários de funcionamento
- Tempo de tolerância para check-in
- Políticas de cancelamento
- Bloqueio automático por clima

2. FINANCEIRO:
- Formas de pagamento aceitas
- Juros e multas
- Desconto para pagamento antecipado
- Dias de tolerância
- Comissões padrão

3. COMUNICAÇÃO:
- Canais ativos (email, WhatsApp, SMS)
- Templates padrão
- Frequência de lembretes
- Horários de envio
- Blacklist de contatos

4. GERAL:
- Fuso horário
- Idioma padrão
- Moeda
- Formato de data/hora
- Logo e cores da marca

5. SEGURANÇA:
- Política de senhas
- Timeout de sessão
- Log de atividades
- Backup automático
- Acesso por IP

SISTEMA DE INTEGRAÇÕES:

1. WHATSAPP (Evolution API):
```typescript
class WhatsAppIntegration {
  async testConnection(): Promise<boolean>
  async configurarWebhook(): Promise<void>
  async sincronizarTemplates(): Promise<void>
  async enviarMensagemTeste(): Promise<void>
}
```

2. ASAAS (Pagamentos):
```typescript
class AsaasIntegration {
  async testConnection(): Promise<boolean>
  async configurarWebhook(): Promise<void>
  async sincronizarClientes(): Promise<void>
  async criarPagamentoTeste(): Promise<void>
}
```

3. N8N (Automações):
```typescript
class N8NIntegration {
  async criarWorkflow(tipo: string): Promise<string>
  async ativarWorkflow(id: string): Promise<void>
  async testarTrigger(workflowId: string): Promise<void>
  async obterLogs(workflowId: string): Promise<any[]>
}
```

AUTOMAÇÕES DISPONÍVEIS:

1. NOVOS USUÁRIOS:
- Enviar email de boas-vindas
- Criar no CRM externo
- Adicionar a lista de WhatsApp
- Agendar follow-up

2. PAGAMENTOS:
- Notificar vencimento
- Processar inadimplência
- Atualizar status no sistema
- Gerar relatório financeiro

3. AULAS:
- Lembrete automático
- Check-in de presença
- Avaliar experiência
- Reagendar reposições

4. MARKETING:
- Campanhas por aniversário
- Reativação de inativos
- Upsell de serviços
- Pesquisa de satisfação

FUNCIONALIDADES AVANÇADAS:

1. WIZARD DE CONFIGURAÇÃO:
- Setup inicial guiado
- Testes de conectividade
- Validação de configurações
- Sugestões otimizadas

2. HEALTH CHECK:
- Monitor de integrações
- Alertas de falha
- Auto-recovery
- Logs detalhados

3. BACKUP AUTOMÁTICO:
```typescript
interface ConfiguracaoBackup {
  frequencia_backup: 'diario' | 'semanal' | 'mensal'
  tipos_dados: string[]
  local_armazenamento: 'supabase' | 's3' | 'google_drive'
  retencao_dias: number
  ultimo_backup?: string
  proximo_backup: string
}
```

4. AUDITORIA:
- Log de todas as alterações
- Rastreamento de quem mudou
- Histórico de configurações
- Rollback de mudanças

COMPONENTES ESPECIAIS:

1. CONFIGURATION FORM:
```typescript
const ConfigurationForm = ({ categoria, configuracoes }) => {
  // Formulário dinâmico baseado no tipo
  // Validação em tempo real
  // Preview das mudanças
  // Confirmação de aplicação
}
```

2. INTEGRATION CARD:
```typescript
const IntegrationCard = ({ integracao, onTest, onConfigure }) => {
  // Status visual da integração
  // Botões de ação
  // Logs recentes
  // Métricas de uso
}
```

3. MODULE TOGGLE:
```typescript
const ModuleToggle = ({ modulo, ativo, onToggle }) => {
  // Switch com confirmação
  // Impacto da ativação/desativação
  // Dependências
  // Permissões necessárias
}
```

VALIDAÇÕES:
- Configurações obrigatórias
- Valores dentro dos limites
- Dependências entre configurações
- Impacto nas funcionalidades

SEGURANÇA:
- Criptografia de API keys
- Sanitização de inputs
- Rate limiting
- Audit trails

Use React Hook Form para formulários complexos e implement real-time validation com Zod.
```

---

## PROMPT 14: MOBILE APP (REACT NATIVE)

```
Desenvolva o aplicativo mobile para alunos e professores.

ESPECIFICAÇÕES TÉCNICAS:
- React Native com Expo
- TypeScript
- React Navigation v6
- Zustand para estado
- React Query para dados
- Expo Camera (QR Code)
- Expo Location
- Push Notifications

ESTRUTURA DO APP:
```
src/
├── app/ (Expo Router)
│   ├── (auth)/
│   ├── (tabs)/
│   └── modal/
├── components/
├── hooks/
├── services/
├── store/
└── utils/
```

FUNCIONALIDADES PRINCIPAIS:

1. AUTENTICAÇÃO:
```typescript
// Tela de Login
const LoginScreen = () => {
  // Formulário responsivo
  // Validação local
  // Biometria (se disponível)
  // Recuperação de senha
}
```

2. HOME DASHBOARD:
```typescript
const HomeScreen = () => {
  // Próximo agendamento destacado
  // Ações rápidas (agendar, pagar, etc)
  // Atividade recente
  // Estatísticas pessoais
  // Notificações importantes
}
```

3. AGENDAMENTOS:
```typescript
const AgendamentosScreen = () => {
  // Lista de agendamentos futuros
  // Histórico
  // Botão de novo agendamento
  // Ações rápidas (cancelar, reagendar)
  // Status visual claro
}

const NovoAgendamentoScreen = () => {
  // Seletor de data (calendário)
  // Horários disponíveis
  // Escolha da quadra
  // Adição de participantes
  // Pagamento integrado
}
```

4. CHECK-IN:
```typescript
const CheckInScreen = () => {
  // Scanner QR Code
  // Check-in por localização
  // Lista de agendamentos do dia
  // Confirmação visual
  // Informações da quadra/horário
}
```

5. AULAS:
```typescript
const AulasScreen = () => {
  // Aulas matriculadas
  // Histórico de presença
  // Evolução do aluno
  // Feedback das aulas
  // Reposições disponíveis
}
```

6. PAGAMENTOS:
```typescript
const PagamentosScreen = () => {
  // Faturas pendentes/pagas
  // Histórico de pagamentos
  // Métodos de pagamento salvos
  // Pagamento via PIX
  // Comprovantes
}
```

7. PERFIL:
```typescript
const PerfilScreen = () => {
  // Dados pessoais
  // Preferências de notificação
  // Histórico de atividades
  // Estatísticas pessoais
  // Configurações do app
}
```

NAVEGAÇÃO:

1. BOTTOM TABS:
- Home (ícone casa)
- Agendamentos (ícone calendário)
- Aulas (ícone graduação)
- Perfil (ícone usuário)

2. STACK NAVIGATION:
- Login/Register Stack
- Main App Stack
- Modals para ações específicas

3. DEEP LINKING:
- Agendamento específico
- Check-in direto
- Pagamento de fatura

COMPONENTES NATIVOS:

1. QR CODE SCANNER:
```typescript
const QRCodeScanner = ({ onScan, onClose }) => {
  // Câmera full-screen
  // Overlay com guias visuais
  // Feedback haptic no scan
  // Permissões de câmera
}
```

2. LOCATION SERVICES:
```typescript
const useLocation = () => {
  // Geolocalização atual
  // Cálculo de distância
  // Permissões de localização
  // Background location (se necessário)
}
```

3. PUSH NOTIFICATIONS:
```typescript
const usePushNotifications = () => {
  // Registro do token
  // Handling de notificações
  // Deep linking das notificações
  // Badge management
}
```

FUNCIONALIDADES ESPECÍFICAS MOBILE:

1. OFFLINE SUPPORT:
- Cache de agendamentos
- Sincronização quando online
- Indicador de status de rede

2. BIOMETRIC AUTH:
- Face ID / Touch ID
- Login rápido
- Segurança adicional

3. HAPTIC FEEDBACK:
- Confirmações de ação
- Sucesso/erro
- Navegação

4. DARK MODE:
- Suporte nativo
- Sincronização com sistema
- Preferência persistente

LAYOUTS RESPONSIVOS:

1. DESIGN SYSTEM MOBILE:
```typescript
const theme = {
  colors: {
    primary: '#0066CC',
    secondary: '#FF6B35',
    background: '#FFFFFF',
    surface: '#F8F9FA',
    text: '#212529'
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32
  },
  borderRadius: {
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16
  }
}
```

2. COMPONENTES BASE:
```typescript
// Button
const Button = ({ variant, size, children, ...props }) => {
  // Diferentes variantes (primary, secondary, outline)
  // Tamanhos (small, medium, large)
  // Estados (loading, disabled)
  // Haptic feedback
}

// Card
const Card = ({ children, ...props }) => {
  // Container com sombra
  // Padding consistente
  // Border radius padrão
}

// Input
const Input = ({ label, error, ...props }) => {
  // Label flutuante
  // Validação visual
  // Ícones opcionais
  // Acessibilidade
}
```

PERFORMANCE:

1. OTIMIZAÇÕES:
- FlatList para listas grandes
- Image lazy loading
- Bundle splitting
- Memory management

2. CACHING:
- React Query cache
- AsyncStorage para preferências
- Image caching
- API response caching

3. ANIMATIONS:
- React Native Reanimated
- Transitions suaves
- Loading states
- Micro-interactions

SEGURANÇA:

1. DATA PROTECTION:
- Keychain para tokens
- Biometric protection
- Certificate pinning
- Ofuscação de código

2. API SECURITY:
- Token refresh automático
- Request signing
- Rate limiting
- Error handling

TESTING:

1. UNIT TESTS:
- Utils e helpers
- Custom hooks
- Service functions

2. INTEGRATION TESTS:
- Navigation flows
- API interactions
- Authentication flows

3. E2E TESTS:
- Detox para fluxos críticos
- Login/logout
- Agendamento completo
- Check-in

BUILD E DEPLOY:

1. EAS BUILD:
- Configuração para iOS/Android
- Code signing automático
- Environment variables
- Build profiles

2. OTA UPDATES:
- Updates automáticos
- Rollback capability
- A/B testing
- Gradual rollout

Use Expo dev tools para desenvolvimento e implement comprehensive error boundary para crash prevention.
```

---

## PROMPT 15: AUTOMAÇÕES E INTEGRAÇÕES FINAIS

```
Finalize o sistema com automações completas e integrações avançadas.

AUTOMAÇÕES N8N:

1. WORKFLOW: NOVO USUÁRIO
```json
{
  "nodes": [
    {
      "name": "Trigger - Novo Usuário",
      "type": "webhook",
      "webhook_url": "/webhook/new-user"
    },
    {
      "name": "Validar Dados",
      "type": "function",
      "code": "// Validação e formatação"
    },
    {
      "name": "Enviar Boas-vindas WhatsApp",
      "type": "http",
      "method": "POST",
      "url": "{{evolution_api_url}}/message/sendText"
    },
    {
      "name": "Criar no Asaas",
      "type": "http", 
      "method": "POST",
      "url": "{{asaas_api_url}}/customers"
    },
    {
      "name": "Agendar Follow-up",
      "type": "schedule",
      "delay": "24h"
    }
  ]
}
```

2. WORKFLOW: PAGAMENTO VENCIDO
```json
{
  "nodes": [
    {
      "name": "Trigger Diário",
      "type": "cron",
      "schedule": "0 9 * * *"
    },
    {
      "name": "Buscar Vencidos",
      "type": "supabase",
      "query": "SELECT * FROM faturas WHERE status = 'vencida'"
    },
    {
      "name": "Loop Clientes",
      "type": "loop"
    },
    {
      "name": "Enviar Cobrança",
      "type": "http",
      "url": "{{whatsapp_api}}/message/sendTemplate"
    },
    {
      "name": "Atualizar Status",
      "type": "supabase",
      "operation": "UPDATE"
    }
  ]
}
```

3. WORKFLOW: LEMBRETE AULA
```json
{
  "nodes": [
    {
      "name": "Trigger - 24h Antes",
      "type": "cron",
      "schedule": "0 10 * * *"
    },
    {
      "name": "Buscar Aulas Amanhã",
      "type": "supabase"
    },
    {
      "name": "Preparar Mensagem",
      "type": "function"
    },
    {
      "name": "Enviar WhatsApp",
      "type": "http"
    },
    {
      "name": "Registrar Notificação",
      "type": "supabase"
    }
  ]
}
```

INTEGRAÇÃO EVOLUTION API:

1. WEBHOOK HANDLER:
```typescript
// app/api/webhooks/whatsapp/route.ts
export async function POST(request: Request) {
  const payload = await request.json()
  
  switch (payload.event) {
    case 'messages.upsert':
      await handleIncomingMessage(payload)
      break
    case 'messages.update':
      await handleMessageUpdate(payload)
      break
    case 'connection.update':
      await handleConnectionUpdate(payload)
      break
  }
  
  return Response.json({ status: 'ok' })
}
```

2. MESSAGE PROCESSOR:
```typescript
const handleIncomingMessage = async (payload: any) => {
  const { messages } = payload
  
  for (const message of messages) {
    if (message.fromMe) continue
    
    const contact = await findContactByPhone(message.key.remoteJid)
    if (!contact) continue
    
    const intent = await detectIntent(message.message.conversation)
    
    switch (intent) {
      case 'check_schedule':
        await sendScheduleInfo(contact, message.key.remoteJid)
        break
      case 'cancel_booking':
        await handleCancellation(contact, message.key.remoteJid)
        break
      case 'make_booking':
        await startBookingFlow(contact, message.key.remoteJid)
        break
      default:
        await sendGeneralHelp(message.key.remoteJid)
    }
  }
}
```

INTEGRAÇÃO ASAAS AVANÇADA:

1. WEBHOOK PROCESSOR:
```typescript
// app/api/webhooks/asaas/route.ts
export async function POST(request: Request) {
  const payload = await request.json()
  const signature = request.headers.get('asaas-signature')
  
  if (!verifySignature(payload, signature)) {
    return Response.json({ error: 'Invalid signature' }, { status: 401 })
  }
  
  switch (payload.event) {
    case 'PAYMENT_CREATED':
      await handlePaymentCreated(payload.payment)
      break
    case 'PAYMENT_CONFIRMED':
      await handlePaymentConfirmed(payload.payment)
      break
    case 'PAYMENT_OVERDUE':
      await handlePaymentOverdue(payload.payment)
      break
    case 'PAYMENT_REFUNDED':
      await handlePaymentRefunded(payload.payment)
      break
  }
  
  return Response.json({ status: 'processed' })
}
```

2. AUTOMATIC BILLING:
```typescript
const generateMonthlyBilling = async () => {
  const activeContracts = await supabase
    .from('contratos')
    .select('*')
    .eq('status', 'ativo')
  
  for (const contract of activeContracts) {
    const dueDate = new Date()
    dueDate.setDate(contract.dia_vencimento)
    
    const payment = await asaasService.createPayment({
      customer: contract.asaas_customer_id,
      billingType: contract.forma_pagamento,
      value: contract.valor_mensal,
      dueDate: dueDate.toISOString(),
      description: `Mensalidade ${format(new Date(), 'MM/yyyy')}`
    })
    
    await supabase.from('faturas').insert({
      cliente_id: contract.cliente_id,
      contrato_id: contract.id,
      valor_original: contract.valor_mensal,
      valor_final: contract.valor_mensal,
      data_vencimento: dueDate.toISOString(),
      asaas_payment_id: payment.id,
      status: 'pendente'
    })
    
    // Trigger notification
    await triggerN8N('payment-created', {
      customer: contract.cliente_id,
      amount: contract.valor_mensal,
      dueDate: dueDate.toISOString()
    })
  }
}
```

SISTEMA DE MONITORAMENTO:

1. HEALTH CHECKS:
```typescript
// app/api/health/route.ts
export async function GET() {
  const checks = await Promise.allSettled([
    checkSupabaseConnection(),
    checkAsaasConnection(),
    checkWhatsAppConnection(),
    checkN8NConnection()
  ])
  
  const results = checks.map((check, index) => ({
    service: ['supabase', 'asaas', 'whatsapp', 'n8n'][index],
    status: check.status === 'fulfilled' ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString()
  }))
  
  const allHealthy = results.every(r => r.status === 'healthy')
  
  return Response.json({
    status: allHealthy ? 'healthy' : 'degraded',
    services: results
  }, {
    status: allHealthy ? 200 : 503
  })
}
```

2. ERROR HANDLING:
```typescript
const globalErrorHandler = (error: Error, context: string) => {
  console.error(`[${context}] Error:`, error)
  
  // Log to Sentry
  Sentry.captureException(error, {
    tags: { context },
    extra: { timestamp: new Date().toISOString() }
  })
  
  // Notify administrators for critical errors
  if (error.message.includes('CRITICAL')) {
    notifyAdmins(error, context)
  }
}
```

CRON JOBS:

1. DAILY MAINTENANCE:
```typescript
// app/api/cron/daily/route.ts
export async function GET() {
  try {
    // Clean expired sessions
    await cleanExpiredSessions()
    
    // Process overdue payments
    await processOverduePayments()
    
    // Generate daily reports
    await generateDailyReports()
    
    // Backup critical data
    await backupCriticalData()
    
    // Health check all integrations
    await healthCheckIntegrations()
    
    return Response.json({ status: 'completed' })
  } catch (error) {
    globalErrorHandler(error, 'daily-cron')
    return Response.json({ error: 'Failed' }, { status: 500 })
  }
}
```

2. WEEKLY REPORTS:
```typescript
// app/api/cron/weekly/route.ts
export async function GET() {
  const arenas = await supabase.from('arenas').select('*').eq('status', 'ativo')
  
  for (const arena of arenas) {
    const weeklyStats = await generateWeeklyStats(arena.id)
    const report = await generateWeeklyReport(weeklyStats)
    
    // Send to arena admin
    await sendEmailReport(arena.email, report)
    
    // Send to super admin (consolidated)
    if (arena.plano_id === 'premium') {
      await sendConsolidatedReport(weeklyStats)
    }
  }
  
  return Response.json({ status: 'reports_sent' })
}
```

CACHE E PERFORMANCE:

1. REDIS CACHE:
```typescript
const cacheService = {
  async get(key: string) {
    return await redis.get(key)
  },
  
  async set(key: string, value: any, ttl = 3600) {
    return await redis.setex(key, ttl, JSON.stringify(value))
  },
  
  async invalidate(pattern: string) {
    const keys = await redis.keys(pattern)
    if (keys.length > 0) {
      await redis.del(...keys)
    }
  }
}
```

2. DATABASE OPTIMIZATION:
```sql
-- Índices otimizados
CREATE INDEX idx_agendamentos_data_arena ON agendamentos(data_agendamento, arena_id);
CREATE INDEX idx_faturas_vencimento_status ON faturas(data_vencimento, status);
CREATE INDEX idx_usuarios_arena_tipo ON usuarios(arena_id, tipo_usuario);
CREATE INDEX idx_checkins_agendamento ON checkins(agendamento_id);

-- Views materialized para relatórios
CREATE MATERIALIZED VIEW vw_occupancy_stats AS
SELECT 
  quadra_id,
  DATE(data_agendamento) as data,
  COUNT(*) as total_agendamentos,
  SUM(EXTRACT(EPOCH FROM (hora_fim - hora_inicio))/3600) as horas_ocupadas
FROM agendamentos
WHERE status_agendamento = 'realizado'
GROUP BY quadra_id, DATE(data_agendamento);
```

SEGURANÇA FINAL:

1. RATE LIMITING:
```typescript
const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP',
  standardHeaders: true,
  legacyHeaders: false,
})
```

2. INPUT SANITIZATION:
```typescript
const sanitizeInput = (input: any) => {
  if (typeof input === 'string') {
    return DOMPurify.sanitize(input)
  }
  if (typeof input === 'object') {
    const sanitized: any = {}
    for (const key in input) {
      sanitized[key] = sanitizeInput(input[key])
    }
    return sanitized
  }
  return input
}
```

Use Vercel Cron Jobs para agendamentos e implement comprehensive logging com structured format.
```

---

## INSTRUÇÕES FINAIS PARA O LOVABLE

### **ORDEM DE IMPLEMENTAÇÃO:**
1. Comece sempre pelo **Prompt 1** (Configuração Inicial)
2. Execute os prompts em sequência numérica
3. Teste cada módulo antes de passar ao próximo
4. Use os wireframes como referência visual
5. Mantenha a arquitetura técnica definida

### **VALIDAÇÕES IMPORTANTES:**
- Teste todas as integrações em ambiente sandbox primeiro
- Implemente tratamento de erro robusto
- Use TypeScript rigorosamente
- Mantenha performance otimizada
- Garanta responsividade completa

### **CONSIDERAÇÕES ESPECIAIS:**
- O sistema é multi-tenant, sempre valide isolamento de dados
- Permissões devem ser verificadas em todas as operações
- Use Row Level Security no Supabase
- Implemente logging completo para auditoria
- Cache estratégico para performance

---

**Status:** ✅ Prompts completos para Lovable criados  
**Total:** 15 prompts detalhados cobrindo todo o sistema  
**Estimativa:** 8-12 meses de desenvolvimento completo