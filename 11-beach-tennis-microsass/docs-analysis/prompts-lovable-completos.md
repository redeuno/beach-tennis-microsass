# VERANA BEACH TENNIS - PROMPTS COMPLETOS PARA LOVABLE

**Versão: 2.0.0**  
**Data: 28/09/2025**  
**Stack: Next.js 14 + Supabase + Multi-tenant**

---

## PROMPT 1: CONFIGURAÇÃO INICIAL E ESTRUTURA BASE

```
Crie uma aplicação Next.js 14 completa para gestão de arenas de Beach Tennis com as seguintes especificações:

### CONFIGURAÇÃO TÉCNICA:
- Next.js 14 com App Router e TypeScript
- Supabase para backend (banco de dados, auth e storage)
- Tailwind CSS + Shadcn/UI para interface
- Sistema multi-tenant com Row Level Security (RLS)
- Zustand para gerenciamento de estado
- React Hook Form + Zod para formulários
- React Query para cache e sincronização

### ARQUITETURA MULTI-TENANT:
1. **Super Admin**: Controla todas as arenas, libera módulos, relatórios globais
2. **Arena Admin**: Gestão completa da arena, configuração de visibilidade de relatórios
3. **Funcionário**: Acesso conforme permissões definidas
4. **Professor**: Gestão de aulas, alunos e relatórios permitidos
5. **Aluno**: Agendamentos, relatórios pessoais conforme configuração

### ESTRUTURA DE PASTAS:
```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   └── register/
│   ├── (super-admin)/
│   │   ├── arenas/
│   │   ├── modulos/
│   │   └── relatorios-globais/
│   ├── (dashboard)/
│   │   ├── quadras/
│   │   ├── agendamentos/
│   │   ├── aulas/
│   │   ├── financeiro/
│   │   ├── torneios/
│   │   ├── comunicacao/
│   │   ├── relatorios/
│   │   └── configuracoes/
│   └── layout.tsx
├── components/
│   ├── ui/ (shadcn components)
│   ├── forms/
│   ├── tables/
│   ├── charts/
│   └── layout/
├── lib/
│   ├── supabase/
│   ├── auth/
│   ├── validations/
│   └── utils/
├── stores/
├── types/
└── hooks/
```

### CONFIGURAÇÃO SUPABASE:
- Configure as variáveis de ambiente para Supabase
- Implemente autenticação com RLS
- Configure Row Level Security para isolamento por arena
- Crie tipos TypeScript para todas as tabelas

### COMPONENTES UI INICIAIS:
- Layout principal com sidebar responsiva
- Header com informações do usuário e arena
- Componentes de navegação baseados em permissões
- Sistema de notificações toast
- Loading states e error boundaries

Implemente a estrutura base e mostre como ela ficará visualmente.
```

---

## PROMPT 2: SISTEMA DE AUTENTICAÇÃO E CONTROLE DE ACESSO

```
Implemente o sistema completo de autenticação e controle de acesso com as seguintes funcionalidades:

### AUTENTICAÇÃO:
1. **Tela de Login**: Email/senha com validação
2. **Registro de Arena**: Para novos clientes (super admin aprova)
3. **Reset de Senha**: Via email com Supabase Auth
4. **Convite de Usuários**: Arena admin convida funcionários/professores

### CONTROLE DE PERMISSÕES:
```typescript
// Tipos de roles e permissões
type UserRole = 'super_admin' | 'arena_admin' | 'funcionario' | 'professor' | 'aluno';

interface UserPermissions {
  arenas: {
    create: boolean;
    read: boolean;
    update: boolean;
    delete: boolean;
  };
  usuarios: {
    create: boolean;
    read: boolean;
    update: boolean;
    delete: boolean;
    roles_permitidas: UserRole[];
  };
  modulos: {
    gerenciar: boolean;
    configurar: boolean;
  };
  relatorios: {
    visualizar: string[]; // códigos dos relatórios
    configurar: boolean;
  };
  // ... outras permissões por módulo
}
```

### MIDDLEWARE DE PROTEÇÃO:
- Middleware para verificar autenticação em rotas protegidas
- Hook useAuth() para verificar permissões específicas
- Componente ProtectedRoute para controlar acesso
- Guards baseados em roles para diferentes áreas

### COMPONENTES DE AUTH:
- AuthProvider para contexto global
- LoginForm com validação Zod
- RegisterArenaForm para novos clientes
- UserInviteForm para convites
- PermissionGate para mostrar/ocultar elementos baseado em permissões

### INTEGRAÇÃO SUPABASE:
- Configure RLS policies conforme especificado no schema
- Implemente funções de auth (login, logout, register)
- Crie sistema de convites por email
- Configure multi-tenant isolation

Mostre exemplos de uso do sistema de permissões e como ele aparece na interface.
```

---

## PROMPT 3: GESTÃO DE MÓDULOS (SUPER ADMIN)

```
Crie o sistema completo de gestão de módulos para Super Admins com as seguintes funcionalidades:

### CRUD DE MÓDULOS DO SISTEMA:
1. **Listagem de Módulos**: Tabela com todos os módulos disponíveis
2. **Criar Módulo**: Formulário para novos módulos com:
   - Nome, código único, tipo (core/premium/integracao)
   - Descrição, ícone, ordem de exibição
   - Dependências de outros módulos
   - Configurações padrão (JSON)
   - Status (ativo/inativo/beta/deprecated)

3. **Editar Módulo**: Atualizar informações e configurações
4. **Ativar/Desativar**: Controle de disponibilidade

### GESTÃO POR ARENA:
```typescript
interface ArenaModulo {
  id: string;
  arena_id: string;
  modulo_id: string;
  ativo: boolean;
  configuracoes: Record<string, any>;
  data_ativacao: string;
  data_desativacao?: string;
}
```

1. **Visualização por Arena**: Lista de arenas com módulos habilitados/desabilitados
2. **Liberar/Bloquear Módulos**: Toggle para cada arena
3. **Configurações Específicas**: Personalizar funcionamento por arena
4. **Histórico de Alterações**: Log de ativações/desativações

### COMPONENTES NECESSÁRIOS:
- ModulosList: Tabela com filtros e ações
- ModuloForm: Formulário de criação/edição
- ArenaModulosGrid: Grid mostrando status por arena
- ModuloToggle: Switch para ativar/desativar
- ModuloConfigModal: Configurações específicas
- DependencyTree: Visualização de dependências

### INTERFACE:
- Dashboard com estatísticas de uso de módulos
- Filtros por tipo, status, arena
- Busca por nome/código
- Ações em lote para múltiplas arenas
- Alertas para dependências não atendidas

### VALIDAÇÕES:
- Não permitir desativar módulos core
- Verificar dependências antes de desativar
- Validar configurações JSON
- Controle de acesso apenas para super_admin

Implemente com interface moderna e responsiva usando Shadcn/UI.
```

---

## PROMPT 4: SISTEMA DE RELATÓRIOS CONFIGURÁVEL

```
Desenvolva o sistema completo de relatórios configurável com as seguintes especificações:

### TIPOS DE RELATÓRIOS:
```typescript
type TipoRelatorio = 'operacional' | 'financeiro' | 'marketing' | 'performance' | 'administrativo';
type NivelAcesso = 'publico' | 'professor' | 'funcionario' | 'admin' | 'super_admin';

interface RelatorioSistema {
  id: string;
  nome: string;
  codigo: string;
  tipo: TipoRelatorio;
  nivel_minimo: NivelAcesso;
  modulo_id: string;
  parametros: Record<string, any>;
  query_base?: string;
}

interface ArenaRelatorioConfig {
  id: string;
  arena_id: string;
  relatorio_id: string;
  nivel_acesso: NivelAcesso;
  visivel_para_professores: boolean;
  visivel_para_alunos: boolean;
  configuracoes: Record<string, any>;
}
```

### RELATÓRIOS PADRÃO:
1. **Dashboard Principal**: Métricas gerais (todos os níveis)
2. **Ocupação de Quadras**: Utilização por período (funcionário+)
3. **Performance Financeira**: Receitas, inadimplência (admin)
4. **Relatório de Alunos**: Frequência, evolução (professor+)
5. **Ranking de Torneios**: Classificações públicas (público)
6. **Relatório Individual**: Performance pessoal (aluno)

### SUPER ADMIN - RELATÓRIOS GLOBAIS:
- Dashboard consolidado de todas as arenas
- Comparativo de performance entre arenas
- Uso de módulos por arena
- Métricas de crescimento do negócio

### ARENA ADMIN - CONFIGURAÇÃO:
```tsx
interface ConfigVisibilidadeProps {
  relatorio: RelatorioSistema;
  arena_id: string;
}

const ConfigVisibilidadeRelatorio = ({ relatorio, arena_id }: ConfigVisibilidadeProps) => {
  // Interface para configurar:
  // - Quais relatórios professores podem ver
  // - Quais relatórios alunos podem acessar
  // - Personalizar parâmetros por nível
  // - Filtros automáticos por usuário
};
```

### COMPONENTES NECESSÁRIOS:
- RelatoriosList: Lista de relatórios disponíveis
- RelatorioViewer: Visualizador universal de relatórios
- ConfigVisibilidade: Configuração de acesso por arena
- RelatorioBuilder: Constructor visual de relatórios
- ChartComponents: Gráficos (Recharts) reutilizáveis
- ExportOptions: PDF, Excel, CSV

### FUNCIONALIDADES:
1. **Filtros Dinâmicos**: Por período, modalidade, usuário
2. **Exportação**: PDF, Excel, CSV com formatação
3. **Agendamento**: Envio automático por email
4. **Favoritos**: Usuários podem salvar relatórios
5. **Compartilhamento**: Links seguros para relatórios

### PERFORMANCE:
- Cache inteligente com React Query
- Lazy loading de dados grandes
- Paginação server-side
- Debounce em filtros dinâmicos

Implemente com design moderno, charts interativos e UX intuitiva.
```

---

## PROMPT 5: GESTÃO DE QUADRAS E AGENDAMENTOS

```
Desenvolva o sistema completo de gestão de quadras e agendamentos com as seguintes funcionalidades:

### CRUD DE QUADRAS:
```typescript
interface Quadra {
  id: string;
  arena_id: string;
  nome: string;
  numero: number;
  tipo_esporte: 'beach_tennis' | 'padel' | 'tenis' | 'futevolei';
  tipo_piso: 'areia' | 'saibro' | 'sintetico' | 'concreto';
  largura: number;
  comprimento: number;
  tem_cobertura: boolean;
  tem_iluminacao: boolean;
  capacidade_maxima: number;
  valor_hora_pico: number;
  valor_hora_normal: number;
  horario_abertura: string;
  horario_fechamento: string;
  dias_funcionamento: string[];
  status: 'ativo' | 'inativo' | 'manutencao';
}
```

### SISTEMA DE AGENDAMENTOS:
1. **Calendário Visual**: FullCalendar.js com:
   - Visualização por dia/semana/mês
   - Drag & drop para reagendar
   - Cores por tipo de agendamento
   - Tooltip com detalhes rápidos

2. **Novo Agendamento**: Modal com 3 etapas:
   - **Quando**: Seletor de data/hora com validação de disponibilidade
   - **Onde**: Escolha de quadra com filtros por modalidade
   - **Quem**: Seleção de participantes + configurações

### VALIDAÇÕES INTELIGENTES:
```typescript
interface ValidacaoAgendamento {
  conflitos_horario: boolean;
  capacidade_maxima: boolean;
  antecedencia_minima: boolean;
  antecedencia_maxima: boolean;
  horario_funcionamento: boolean;
  disponibilidade_professor?: boolean;
}
```

### FUNCIONALIDADES AVANÇADAS:
1. **Recorrência**: Agendamentos repetitivos com configuração flexível
2. **Lista de Espera**: Sistema automático quando quadra ocupada
3. **Check-in**: QR Code, geolocalização, manual, biometria
4. **Notificações**: WhatsApp, email, push para lembretes
5. **Cancelamento**: Políticas flexíveis de cancelamento

### COMPONENTES:
- QuadrasList: Tabela com filtros e ações rápidas
- QuadraForm: Formulário completo com validações
- CalendarioAgendamentos: Interface principal de agendamentos
- AgendamentoModal: Wizard de 3 etapas para novo agendamento
- CheckInComponent: Interface de check-in com múltiplas opções
- DisponibilidadeGrid: Visualização rápida de horários livres

### INTERFACE:
- Dashboard de ocupação em tempo real
- Filtros por quadra, modalidade, período
- Busca rápida por cliente/professor
- Ações em lote (cancelar, reagendar)
- Indicadores visuais de status

### INTEGRAÇÕES:
- WhatsApp via Evolution API para confirmações
- Sistema de pagamentos para agendamentos avulsos
- Integração com contratos para desconto de mensalidades

Implemente com UX moderna, responsiva e performance otimizada.
```

---

## PROMPT 6: GESTÃO DE USUÁRIOS E PERFIS

```
Crie o sistema completo de gestão de usuários com perfis específicos para arena de Beach Tennis:

### TIPOS DE USUÁRIO:
```typescript
interface Usuario {
  id: string;
  arena_id: string;
  auth_id: string;
  nome: string;
  sobrenome: string;
  email: string;
  telefone: string;
  whatsapp: string;
  cpf: string;
  data_nascimento: Date;
  genero: 'masculino' | 'feminino' | 'outro';
  role: 'super_admin' | 'arena_admin' | 'funcionario' | 'professor' | 'aluno';
  
  // Dados esportivos
  esportes_praticados: string[];
  nivel_jogo: 'iniciante' | 'intermediario' | 'avancado' | 'profissional';
  dominancia: 'destro' | 'canhoto' | 'ambidestro';
  posicao_preferida: 'rede' | 'fundo' | 'ambas';
  
  // Dados profissionais (professor/funcionário)
  cargo?: string;
  salario?: number;
  comissao_percentual?: number;
  
  // Dados médicos
  tipo_sanguineo?: string;
  alergias?: string;
  contato_emergencia_nome?: string;
  contato_emergencia_telefone?: string;
}
```

### CRUD COMPLETO:
1. **Listagem**: Tabela com filtros por role, status, modalidade
2. **Criar**: Formulário adaptativo baseado no role selecionado
3. **Editar**: Atualização de dados com histórico de alterações
4. **Visualizar**: Perfil completo com dados esportivos e histórico
5. **Desativar**: Soft delete com possibilidade de reativação

### PERFIS ESPECÍFICOS:

#### ALUNO:
- Histórico de aulas e frequência
- Evolução técnica e avaliações
- Contratos ativos e mensalidades
- Ranking em torneios
- Estatísticas de jogo

#### PROFESSOR:
- Agenda de aulas e disponibilidade
- Lista de alunos e evolução
- Receitas e comissões
- Avaliações recebidas
- Certificações e especializações

#### FUNCIONÁRIO:
- Permissões específicas por módulo
- Histórico de ações no sistema
- Horários de trabalho
- Metas e KPIs

### FUNCIONALIDADES AVANÇADAS:
1. **Import em Lote**: Upload CSV com validação
2. **Convite por Email**: Sistema de convites com roles pré-definidos
3. **Documentos**: Upload de RG, CPF, atestados médicos
4. **Foto de Perfil**: Upload com redimensionamento automático
5. **Comunicação**: Histórico de mensagens enviadas

### COMPONENTES:
```tsx
// Componentes principais
const UsuariosList = () => { /* Tabela com filtros avançados */ };
const UsuarioForm = ({ mode, userId }: { mode: 'create' | 'edit'; userId?: string }) => { /* Formulário adaptativo */ };
const PerfilCompleto = ({ userId }: { userId: string }) => { /* Visualização completa */ };
const ConviteUsuario = ({ defaultRole }: { defaultRole: UserRole }) => { /* Sistema de convites */ };

// Componentes específicos por role
const DashboardAluno = ({ userId }: { userId: string }) => { /* Dashboard do aluno */ };
const DashboardProfessor = ({ userId }: { userId: string }) => { /* Dashboard do professor */ };
const GerenciadorPermissoes = ({ userId }: { userId: string }) => { /* Gestão de permissões */ };
```

### VALIDAÇÕES:
- CPF único por arena
- Email único no sistema
- Idade mínima para professores
- Documentos obrigatórios por role
- Validação de certificações para professores

### INTERFACE:
- Cards com foto e informações principais
- Filtros rápidos por modalidade praticada
- Busca inteligente (nome, email, CPF)
- Ações rápidas (WhatsApp, email, editar)
- Indicadores visuais de status e role

Implemente com design moderno, formulários inteligentes e UX otimizada para diferentes roles.
```

---

## PROMPT 7: GESTÃO FINANCEIRA E ASAAS

```
Desenvolva o módulo completo de gestão financeira integrado com Asaas:

### CONTRATOS E MENSALIDADES:
```typescript
interface Contrato {
  id: string;
  arena_id: string;
  cliente_id: string;
  numero_contrato: string;
  tipo_plano: 'mensal' | 'trimestral' | 'semestral' | 'anual';
  modalidade: string;
  data_inicio: Date;
  data_fim: Date;
  valor_mensalidade: number;
  aulas_incluidas: number;
  status: 'ativo' | 'suspenso' | 'cancelado' | 'inadimplente';
}

interface Fatura {
  id: string;
  contrato_id: string;
  numero_fatura: string;
  competencia: Date;
  data_vencimento: Date;
  valor_total: number;
  status: 'pendente' | 'paga' | 'vencida' | 'cancelada';
  asaas_payment_id?: string;
  forma_pagamento?: string;
}
```

### INTEGRAÇÃO ASAAS:
1. **Configuração**: Sandbox/Produção, API Key, Webhook
2. **Clientes**: Sincronização automática com Asaas
3. **Cobrança**: Geração automática de boletos, PIX, cartão
4. **Webhooks**: Atualização automática de status de pagamento
5. **Conciliação**: Matching automático de pagamentos

### FUNCIONALIDADES:
1. **Dashboard Financeiro**:
   - Resumo de receitas por período
   - Inadimplência em tempo real
   - Gráficos de faturamento
   - Previsão de recebimentos

2. **Gestão de Contratos**:
   - Criação com templates pré-definidos
   - Renovação automática
   - Suspensão temporária
   - Políticas de desconto

3. **Faturamento**:
   - Geração automática mensal
   - Cobrança recorrente via Asaas
   - Reenvio de boletos
   - Parcelamento de débitos

4. **Movimentações**:
   - Registro de receitas/despesas
   - Categorização automática
   - Conciliação bancária
   - Relatórios financeiros

### COMPONENTES:
```tsx
const DashboardFinanceiro = () => {
  // Cards com métricas principais
  // Gráficos de receita e inadimplência
  // Tabela de vencimentos próximos
};

const ContratoForm = ({ mode, contratoId }: FormProps) => {
  // Formulário com cálculos automáticos
  // Seleção de planos e descontos
  // Integração com Asaas para criar customer
};

const FaturasList = () => {
  // Tabela com filtros por status
  // Ações: reenviar, cancelar, parcelar
  // Sincronização com status Asaas
};

const MovimentacaoForm = () => {
  // Registro de receitas/despesas
  // Upload de comprovantes
  // Categorização automática
};
```

### AUTOMAÇÕES:
1. **Cobrança Automática**: Geração no dia do vencimento
2. **Lembretes**: WhatsApp/Email antes do vencimento
3. **Inadimplência**: Suspensão automática após X dias
4. **Reativação**: Liberação automática após pagamento

### RELATÓRIOS FINANCEIROS:
- DRE (Demonstrativo de Resultado)
- Fluxo de caixa projetado
- Análise de inadimplência
- Comparativo mensal/anual
- Relatório de comissões

### CONFIGURAÇÕES ASAAS:
```typescript
interface AsaasConfig {
  environment: 'sandbox' | 'production';
  api_key: string;
  webhook_url: string;
  default_payment_methods: string[];
  interest_rate: number; // Taxa de juros
  fine_rate: number; // Multa por atraso
}
```

Implemente com interface intuitiva, automações inteligentes e integração robusta com Asaas.
```

---

## PROMPT 8: SISTEMA DE AULAS E CHECK-IN

```
Desenvolva o sistema completo de gestão de aulas com check-in avançado:

### GESTÃO DE AULAS:
```typescript
interface Aula {
  id: string;
  arena_id: string;
  agendamento_id: string;
  professor_id: string;
  tipo_aula: 'individual' | 'dupla' | 'grupo' | 'clinica';
  modalidade: string;
  nivel_aula: string;
  alunos: string[]; // Array de IDs
  max_alunos: number;
  valor_aula: number;
  duracao_minutos: number;
  objetivos: string;
  material_necessario: string[];
  status: 'confirmada' | 'realizada' | 'cancelada';
  e_reposicao: boolean;
  aula_original_id?: string;
}
```

### SISTEMA DE CHECK-IN MÚLTIPLO:
1. **QR Code**: Geração única por aula
2. **Geolocalização**: Validação dentro da arena
3. **Manual**: Check-in pelo professor/funcionário
4. **Biometria**: Integração futura com dispositivos
5. **Facial**: Reconhecimento via câmera (opcional)

### FUNCIONALIDADES:

#### CHECK-IN POR QR CODE:
```tsx
const CheckInQRCode = ({ aulaId }: { aulaId: string }) => {
  // Geração de QR único por aula
  // Expiração automática após horário
  // Validação de presença em tempo real
  // Interface para scanner (professor/aluno)
};
```

#### CHECK-IN POR GEO:
```tsx
const CheckInGeo = ({ aulaId }: { aulaId: string }) => {
  // Verificação de localização
  // Raio de tolerância configurável
  // Fallback para check-in manual
  // Histórico de localizações
};
```

#### CONTROLE DE REPOSIÇÕES:
```typescript
interface PoliticaReposicao {
  dias_para_reagendar: number;
  motivos_aceitos: string[];
  limite_reposicoes_mes: number;
  professores_substitutos: string[];
  auto_aprovacao: boolean;
}
```

### GESTÃO DE PRESENÇA:
1. **Status Automático**: Presente, ausente, atrasado
2. **Tolerância**: Configurável por arena
3. **Notificações**: Avisos automáticos de ausência
4. **Histórico**: Frequência por aluno/período

### AVALIAÇÕES E EVOLUÇÃO:
```tsx
const AvaliacaoAluno = ({ aulaId, alunoId }: AvaliacaoProps) => {
  // Formulário de avaliação técnica
  // Notas por habilidade
  // Comentários do professor
  // Fotos/vídeos dos movimentos
  // Plano de melhoria
};
```

### COMPONENTES PRINCIPAIS:
1. **AulasList**: Agenda do professor com filtros
2. **AulaForm**: Criação/edição de aulas
3. **CheckInInterface**: Interface unificada de check-in
4. **PresencaControl**: Gestão de presenças em lote
5. **ReposicaoManager**: Sistema de reposições
6. **AvaliacaoTecnica**: Avaliações e evolução

### AUTOMAÇÕES:
1. **Lembretes**: Notificações antes da aula
2. **Check-in Automático**: Para aulas recorrentes
3. **Reposições**: Sugestão automática de datas
4. **Relatórios**: Frequência e evolução automática

### INTERFACE MOBILE-FIRST:
- App nativo React Native para check-in
- Scanner QR code otimizado
- Geolocalização em background
- Sincronização offline
- Push notifications

### RELATÓRIOS DE AULAS:
- Frequência por aluno/período
- Performance dos professores
- Ocupação de horários
- Análise de reposições
- Evolução técnica dos alunos

Implemente com foco em UX mobile e automações inteligentes.
```

---

## PROMPT 9: TORNEIOS E EVENTOS

```
Desenvolva o sistema completo de gestão de torneios e eventos:

### CRUD DE TORNEIOS:
```typescript
interface Torneio {
  id: string;
  arena_id: string;
  nome: string;
  modalidade: string;
  data_inicio: Date;
  data_fim: Date;
  data_limite_inscricao: Date;
  max_participantes: number;
  taxa_inscricao: number;
  premiacao_total: number;
  formato_chaveamento: 'eliminacao_simples' | 'eliminacao_dupla' | 'round_robin';
  categoria_nivel: string;
  categoria_idade_min?: number;
  categoria_idade_max?: number;
  status: 'planejado' | 'inscricoes_abertas' | 'em_andamento' | 'finalizado';
  regulamento: string;
}
```

### SISTEMA DE INSCRIÇÕES:
1. **Formulário Público**: Inscrição online com validações
2. **Pagamento Integrado**: PIX, cartão via Asaas
3. **Documentação**: Upload de comprovantes necessários
4. **Validação**: Aprovação manual/automática
5. **Lista de Espera**: Sistema automático quando lotado

### GERAÇÃO DE CHAVEAMENTO:
```tsx
const ChaveamentoGenerator = ({ torneioId }: { torneioId: string }) => {
  // Algoritmos para diferentes formatos
  // Sorteio automático ou manual
  // Balanceamento por ranking/nível
  // Visualização gráfica das chaves
  // Edição manual de posições
};
```

### GESTÃO DE PARTIDAS:
1. **Cronograma**: Geração automática baseada em quadras disponíveis
2. **Resultados**: Interface rápida para inserção
3. **Validação**: Confirmação de resultados por participantes
4. **Avanço Automático**: Próximas fases automáticas
5. **Live Updates**: Resultados em tempo real

### RANKING E PONTUAÇÃO:
```typescript
interface ResultadoTorneio {
  id: string;
  torneio_id: string;
  inscricao_id: string;
  posicao_final: number;
  pontos_conquistados: number;
  premiacao_recebida: number;
  partidas_jogadas: number;
  vitorias: number;
  derrotas: number;
}
```

### EVENTOS ESPECIAIS:
1. **Clínicas**: Aulas especiais com convidados
2. **Workshops**: Eventos educacionais
3. **Festas**: Eventos sociais da arena
4. **Corporativos**: Eventos para empresas

### COMPONENTES:
```tsx
const TorneioForm = ({ mode, torneioId }: FormProps) => {
  // Wizard multi-etapas
  // Configurações avançadas
  // Preview do cronograma
  // Integração com pagamentos
};

const InscricaoPublica = ({ torneioId }: { torneioId: string }) => {
  // Interface pública para inscrições
  // Formulário otimizado mobile
  // Pagamento online
  // Confirmação automática
};

const ChaveamentoView = ({ torneioId }: { torneioId: string }) => {
  // Visualização das chaves
  // Inserção de resultados
  // Navegação por fases
  // Export para imagem/PDF
};

const RankingTorneios = ({ arena_id }: { arena_id: string }) => {
  // Ranking geral da arena
  // Filtros por modalidade/período
  // Histórico de participações
  // Exportação de dados
};
```

### AUTOMAÇÕES:
1. **Notificações**: Lembretes de jogos por WhatsApp
2. **Sorteio**: Geração automática de chaves
3. **Resultados**: Avanço automático nas fases
4. **Premiação**: Distribuição automática via PIX

### INTERFACE PÚBLICA:
- Landing page do torneio
- Inscrições online
- Visualização de chaves
- Resultados ao vivo
- Galeria de fotos

### RELATÓRIOS:
- Participação por período
- Receita de torneios
- Performance dos participantes
- Análise de modalidades
- ROI de eventos

Implemente com design atrativo e automações inteligentes para reduzir trabalho manual.
```

---

## PROMPT 10: COMUNICAÇÃO E INTEGRAÇÕES

```
Desenvolva o sistema completo de comunicação integrado com WhatsApp:

### INTEGRAÇÃO EVOLUTION API:
```typescript
interface EvolutionConfig {
  instance_name: string;
  api_url: string;
  api_key: string;
  webhook_url: string;
  qr_code?: string;
  status: 'connected' | 'disconnected' | 'qr_pending';
}

interface WhatsAppMessage {
  to: string;
  text?: string;
  media?: {
    type: 'image' | 'document' | 'audio';
    url: string;
    caption?: string;
  };
  template_id?: string;
  variables?: Record<string, string>;
}
```

### SISTEMA DE TEMPLATES:
1. **Templates Padrão**: Agendamento, pagamento, lembrete
2. **Variáveis Dinâmicas**: {nome}, {data}, {horario}, {valor}
3. **Multi-canal**: WhatsApp, Email, SMS, Push
4. **A/B Testing**: Teste de diferentes versões
5. **Agendamento**: Envio em horários específicos

### AUTOMAÇÕES:
```typescript
interface AutomacaoComunicacao {
  trigger: 'agendamento_criado' | 'pagamento_vencido' | 'aula_confirmada';
  delay_minutos: number;
  template_id: string;
  condicoes: {
    usuario_role?: string[];
    modalidade?: string[];
    valor_minimo?: number;
  };
  ativo: boolean;
}
```

### CAMPANHAS DE MARKETING:
1. **Segmentação**: Por idade, modalidade, frequência
2. **Agendamento**: Envio em datas específicas
3. **Métricas**: Taxa de abertura, resposta, conversão
4. **Landing Pages**: Integração com campanhas
5. **Retargeting**: Re-engajamento automático

### HISTÓRICO E ANALYTICS:
```tsx
const ComunicacaoAnalytics = () => {
  // Gráficos de entrega e abertura
  // Taxa de resposta por canal
  // ROI de campanhas
  // Melhor horário de envio
  // Segmentação mais efetiva
};
```

### COMPONENTES:
```tsx
const TemplateManager = () => {
  // CRUD de templates
  // Editor visual com variáveis
  // Preview em tempo real
  // Teste de envio
};

const CampanhaForm = () => {
  // Criação de campanhas
  // Segmentação de audiência
  // Agendamento de envio
  // A/B testing setup
};

const WhatsAppSetup = () => {
  // Configuração Evolution API
  // QR Code para conectar
  // Status da conexão
  // Webhook configuration
};

const ComunicacaoHistorico = () => {
  // Histórico de mensagens
  // Filtros por canal/período
  // Status de entrega
  // Métricas por campanha
};
```

### INTEGRAÇÕES ADICIONAIS:
1. **Resend**: Email transacional e marketing
2. **Twilio**: SMS para casos críticos
3. **Expo Push**: Notificações mobile
4. **n8n**: Automações complexas
5. **Webhooks**: Integrações personalizadas

### FUNCIONALIDADES AVANÇADAS:
1. **Chat em Tempo Real**: Suporte via WhatsApp
2. **Bot Automático**: Respostas automáticas
3. **Broadcast Lists**: Listas de transmissão
4. **Status Stories**: Publicação automática
5. **Grupos**: Gestão de grupos por modalidade

### CONFIGURAÇÕES:
```tsx
const ComunicacaoConfig = () => {
  // Horários permitidos para envio
  // Blacklist de números
  // Templates obrigatórios
  // Limites de envio diário
  // LGPD compliance
};
```

### COMPLIANCE LGPD:
- Opt-in explícito para comunicações
- Unsubscribe em todos os canais
- Auditoria de comunicações
- Consentimento granular por tipo
- Relatórios de compliance

Implemente com foco em automação, compliance e métricas detalhadas.
```

---

## INSTRUÇÕES FINAIS PARA IMPLEMENTAÇÃO

### ORDEM RECOMENDADA:
1. **Prompt 1**: Estrutura base e autenticação
2. **Prompt 2**: Sistema de permissões
3. **Prompt 3**: Gestão de módulos (Super Admin)
4. **Prompt 4**: Sistema de relatórios
5. **Prompt 5**: Quadras e agendamentos
6. **Prompt 6**: Gestão de usuários
7. **Prompt 7**: Financeiro e Asaas
8. **Prompt 8**: Aulas e check-in
9. **Prompt 9**: Torneios e eventos
10. **Prompt 10**: Comunicação e integrações

### CONFIGURAÇÕES IMPORTANTES:
- Configure as variáveis de ambiente do Supabase
- Execute os schemas SQL antes dos prompts de frontend
- Configure Row Level Security adequadamente
- Teste cada módulo isoladamente
- Implemente testes unitários para funções críticas

### DEPLOYMENT:
- Frontend: Vercel
- Backend: Supabase
- Mobile: Expo EAS
- Monitoramento: Sentry

**Status:** ✅ Prompts completos prontos para implementação no Lovable