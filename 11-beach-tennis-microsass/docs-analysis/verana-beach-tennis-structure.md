# VERANA BEACH TENNIS - ESTRUTURA COMPLETA DO SISTEMA CRM/ERP

**Versão: 1.1.0**  
**Data: 27/09/2025**  
**Tipo: Sistema Multi-tenant White-label**
**Revisão: Estrutura completa com todos os CRUDs e controle de módulos**

---

## STACK TECNOLÓGICO

- **Backend:** Supabase (PostgreSQL + APIs + Auth)
- **Frontend:** React.js / Next.js
- **Mobile:** React Native / Flutter
- **Automações:** n8n + Webhooks
- **WhatsApp:** Evolution API
- **Pagamentos:** Asaas
- **Deploy:** Vercel/Netlify + Supabase Cloud

---

## ARQUITETURA MULTI-TENANT

### HIERARQUIA DE USUÁRIOS

1. **SUPER ADMIN** (Você - White-label Owner)
   - Controle total de todas as arenas
   - Ativação/desativação de módulos por arena
   - Acesso a relatórios consolidados de todas as arenas
   - Gestão de planos e cobrança das arenas

2. **ADMIN ARENA** (Cliente - Dono da Arena)
   - Gestão completa da arena específica
   - Acesso apenas aos módulos liberados pelo Super Admin
   - Configuração de relatórios visíveis para professores/alunos
   - Gestão de equipe e clientes

3. **FUNCIONÁRIOS** (Staff da Arena)
   - Acesso limitado conforme permissões definidas pelo Admin Arena
   - Operações do dia-a-dia
   - Relatórios operacionais básicos

4. **PROFESSORES** (Instrutores)
   - Gestão de suas aulas e alunos
   - Relatórios de desempenho (conforme liberado pela arena)
   - Agenda pessoal e comissões

5. **ALUNOS/CLIENTES** (Usuários finais)
   - App mobile para agendamentos
   - Histórico pessoal e evolução (conforme liberado pela arena)
   - Pagamentos e faturas

### CONTROLE DE MÓDULOS POR ARENA

| Módulo | Plano Básico | Plano Pro | Plano Premium |
|--------|--------------|-----------|---------------|
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

## ESTRUTURA COMPLETA DE MÓDULOS E MENUS

### 🔧 MÓDULO 0: SUPER ADMIN (White-label Management)

#### 0.1 Menu: Planos do Sistema
**CRUD:** planos_sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do plano |
| nome | String(100) | ✅ | Nome do plano (Básico, Pro, Premium) |
| valor_mensal | Decimal(8,2) | ✅ | Valor mensal do plano |
| max_quadras | Integer | ✅ | Máximo de quadras permitidas |
| max_usuarios | Integer | ✅ | Máximo de usuários |
| modulos_inclusos | JSON | ✅ | Lista de módulos inclusos |
| recursos_extras | JSON | ❌ | Recursos adicionais |
| descricao | Text | ❌ | Descrição do plano |
| status | Enum | ✅ | ativo, inativo |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 0.2 Menu: Gestão de Arenas (Super Admin)
**CRUD:** arenas_planos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| plano_sistema_id | UUID | ✅ | FK para plano do sistema |
| modulos_ativos | JSON | ✅ | Módulos atualmente ativos |
| modulos_bloqueados | JSON | ❌ | Módulos bloqueados manualmente |
| data_inicio | Date | ✅ | Início da assinatura |
| data_vencimento | Date | ✅ | Vencimento atual |
| valor_pago | Decimal(8,2) | ✅ | Valor pago pela arena |
| status | Enum | ✅ | ativo, suspenso, cancelado |
| observacoes | Text | ❌ | Observações |

#### 0.3 Menu: Faturamento de Arenas
**CRUD:** faturas_sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da fatura |
| arena_id | UUID | ✅ | FK para arena |
| referencia_mes | Date | ✅ | Mês de referência |
| valor_plano | Decimal(8,2) | ✅ | Valor do plano |
| valor_extras | Decimal(8,2) | ❌ | Valores extras |
| valor_total | Decimal(8,2) | ✅ | Valor total |
| data_vencimento | Date | ✅ | Data vencimento |
| data_pagamento | DateTime | ❌ | Data do pagamento |
| status | Enum | ✅ | pendente, paga, vencida |
| forma_pagamento | Enum | ❌ | Como foi pago |

#### 0.4 Menu: Relatórios Consolidados
**Dados de todas as arenas:**
- Total de arenas ativas por plano
- Receita mensal do sistema
- Uso por módulo/funcionalidade
- Métricas de engajamento
- Churn rate de arenas

**Operações CRUD:**
- ✅ Create: Criar planos e configurações
- ✅ Read: Visualizar todas as informações
- ✅ Update: Editar planos e configurações
- ✅ Delete: Inativar (não deletar)

---

### 🏢 MÓDULO 1: GESTÃO DE ARENAS (Multi-tenant)

#### 1.1 Menu: Minha Arena
**CRUD:** arenas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da arena |
| tenant_id | UUID | ✅ | ID do tenant |
| nome | String(100) | ✅ | Nome da arena |
| razao_social | String(200) | ✅ | Razão social |
| cnpj | String(18) | ✅ | CNPJ formatado |
| telefone | String(15) | ✅ | Telefone principal |
| whatsapp | String(15) | ✅ | WhatsApp business |
| email | String(100) | ✅ | Email principal |
| endereco_completo | JSON | ✅ | CEP, rua, número, bairro, cidade, UF |
| coordenadas | Point | ❌ | Lat/Long para geolocalização |
| logo_url | String | ❌ | URL da logo |
| cores_tema | JSON | ❌ | Cores personalizadas |
| horario_funcionamento | JSON | ✅ | Horários por dia da semana |
| configuracoes | JSON | ❌ | Configs específicas |
| status | Enum | ✅ | ativo, inativo, suspenso |
| plano_id | UUID | ✅ | Plano contratado |
| data_vencimento | Date | ✅ | Vencimento da mensalidade |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 1.2 Menu: Configurações da Arena
**CRUD:** configuracoes_arena

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| categoria | Enum | ✅ | agendamento, financeiro, comunicacao, geral |
| chave | String(100) | ✅ | Nome da configuração |
| valor | JSON | ✅ | Valor da configuração |
| descricao | Text | ❌ | Descrição |
| editavel | Boolean | ✅ | Se pode ser editada |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 1.3 Menu: Políticas de Negócio
**CRUD:** politicas_negocio

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| tipo_politica | Enum | ✅ | cancelamento, reposicao, pagamento, pontualidade |
| nome | String(100) | ✅ | Nome da política |
| regras | JSON | ✅ | Regras estruturadas |
| descricao | Text | ✅ | Descrição detalhada |
| ativa | Boolean | ✅ | Se está ativa |
| data_vigencia | Date | ✅ | Desde quando vale |
| created_at | Timestamp | ✅ | Data criação |

**Operações CRUD:**
- ✅ Create: Cadastro inicial da arena
- ✅ Read: Visualizar dados da arena
- ✅ Update: Editar informações
- ❌ Delete: Apenas inativação

---

### 🏟️ MÓDULO 2: GESTÃO DE QUADRAS

#### 2.1 Menu: Cadastro de Quadras
**CRUD:** quadras

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da quadra |
| arena_id | UUID | ✅ | FK para arena |
| nome | String(50) | ✅ | Nome/número da quadra |
| tipo_esporte | Enum | ✅ | beach_tennis, padel, tenis |
| tipo_piso | Enum | ✅ | areia, saibro, sintético, concreto |
| cobertura | Boolean | ✅ | Tem cobertura |
| iluminacao | Boolean | ✅ | Tem iluminação |
| dimensoes | JSON | ❌ | Largura x Comprimento |
| capacidade_jogadores | Integer | ✅ | Máx. jogadores simultâneos |
| valor_hora_pico | Decimal(8,2) | ✅ | Preço horário pico |
| valor_hora_normal | Decimal(8,2) | ✅ | Preço horário normal |
| horarios_pico | JSON | ✅ | Horários de pico por dia |
| equipamentos_inclusos | JSON | ❌ | Lista de equipamentos |
| observacoes | Text | ❌ | Observações gerais |
| status | Enum | ✅ | ativa, manutenção, inativa |
| ultima_manutencao | Date | ❌ | Data última manutenção |
| proxima_manutencao | Date | ❌ | Data próxima manutenção |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 2.2 Menu: Bloqueios e Manutenções
**CRUD:** quadras_bloqueios

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do bloqueio |
| quadra_id | UUID | ✅ | FK para quadra |
| tipo_bloqueio | Enum | ✅ | manutenção, evento, clima, outro |
| data_inicio | DateTime | ✅ | Início do bloqueio |
| data_fim | DateTime | ✅ | Fim do bloqueio |
| motivo | String(200) | ✅ | Motivo do bloqueio |
| responsavel_id | UUID | ❌ | Quem criou o bloqueio |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | ativo, cancelado, finalizado |

#### 2.3 Menu: Histórico de Manutenções
**CRUD:** manutencoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da manutenção |
| quadra_id | UUID | ✅ | FK para quadra |
| tipo_manutencao | Enum | ✅ | preventiva, corretiva, emergencial |
| data_manutencao | Date | ✅ | Data da manutenção |
| descricao | Text | ✅ | Descrição do que foi feito |
| fornecedor | String(100) | ❌ | Empresa responsável |
| valor_gasto | Decimal(8,2) | ❌ | Valor gasto |
| tempo_parada | Integer | ❌ | Horas de parada |
| responsavel_id | UUID | ✅ | Quem registrou |
| proximo_agendamento | Date | ❌ | Próxima manutenção |
| anexos | JSON | ❌ | Fotos/documentos |
| status | Enum | ✅ | concluida, pendente, cancelada |

#### 2.4 Menu: Equipamentos da Quadra
**CRUD:** equipamentos_quadra

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| quadra_id | UUID | ✅ | FK para quadra |
| nome_equipamento | String(100) | ✅ | Nome do equipamento |
| tipo | Enum | ✅ | rede, raquete, bola, iluminacao, outro |
| marca | String(50) | ❌ | Marca |
| modelo | String(50) | ❌ | Modelo |
| data_aquisicao | Date | ❌ | Data da compra |
| valor_aquisicao | Decimal(8,2) | ❌ | Valor pago |
| vida_util_estimada | Integer | ❌ | Meses de vida útil |
| status | Enum | ✅ | novo, bom, regular, ruim, descartado |
| observacoes | Text | ❌ | Observações |

**Operações CRUD:**
- ✅ Create: Criar quadras, bloqueios, manutenções
- ✅ Read: Listar e visualizar
- ✅ Update: Editar informações
- ✅ Delete: Inativar/cancelar

---

### 👥 MÓDULO 3: GESTÃO DE PESSOAS

#### 3.1 Menu: Alunos/Clientes
**CRUD:** usuarios

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do usuário |
| arena_id | UUID | ✅ | FK para arena |
| tipo_usuario | Enum | ✅ | aluno, professor, funcionario, admin |
| nome_completo | String(150) | ✅ | Nome completo |
| email | String(100) | ✅ | Email único |
| telefone | String(15) | ✅ | Telefone |
| whatsapp | String(15) | ❌ | WhatsApp (pode ser igual telefone) |
| cpf | String(14) | ✅ | CPF formatado |
| data_nascimento | Date | ✅ | Data nascimento |
| genero | Enum | ❌ | masculino, feminino, outro |
| endereco | JSON | ❌ | Endereço completo |
| nivel_jogo | Enum | ❌ | iniciante, intermediário, avançado, profissional |
| dominancia | Enum | ❌ | destro, canhoto, ambidestro |
| posicao_preferida | Enum | ❌ | rede, fundo, ambas |
| observacoes_medicas | Text | ❌ | Restrições médicas |
| contato_emergencia | JSON | ❌ | Nome e telefone |
| foto_url | String | ❌ | URL da foto |
| status | Enum | ✅ | ativo, inativo, suspenso |
| data_cadastro | Date | ✅ | Data do cadastro |
| ultimo_acesso | DateTime | ❌ | Último login |
| aceite_termos | Boolean | ✅ | Aceitou termos de uso |
| aceite_marketing | Boolean | ❌ | Aceitou receber marketing |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 3.2 Menu: Professores
**CRUD:** professores (extends usuarios)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| usuario_id | UUID | ✅ | FK para usuarios |
| registro_profissional | String(50) | ❌ | CREF ou similar |
| especialidades | JSON | ✅ | Modalidades que ensina |
| valor_hora_aula | Decimal(8,2) | ✅ | Valor por hora |
| percentual_comissao | Decimal(5,2) | ❌ | % sobre vendas |
| disponibilidade | JSON | ✅ | Horários disponíveis |
| biografia | Text | ❌ | Apresentação do professor |
| certificacoes | JSON | ❌ | Lista de certificações |
| experiencia_anos | Integer | ❌ | Anos de experiência |
| status_professor | Enum | ✅ | ativo, inativo, licenca |

#### 3.3 Menu: Funcionários
**CRUD:** funcionarios (extends usuarios)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| usuario_id | UUID | ✅ | FK para usuarios |
| cargo | String(50) | ✅ | Cargo/função |
| salario | Decimal(8,2) | ❌ | Salário (se aplicável) |
| permissoes | JSON | ✅ | Módulos que pode acessar |
| horario_trabalho | JSON | ✅ | Horários de trabalho |
| data_admissao | Date | ✅ | Data de admissão |
| data_demissao | Date | ❌ | Data demissão (se aplicável) |

#### 3.4 Menu: Histórico de Atividades
**CRUD:** historico_atividades

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| usuario_id | UUID | ✅ | FK para usuario |
| arena_id | UUID | ✅ | FK para arena |
| tipo_atividade | Enum | ✅ | agendamento, aula, pagamento, cancelamento |
| descricao | String(200) | ✅ | Descrição da atividade |
| detalhes | JSON | ❌ | Detalhes adicionais |
| data_atividade | DateTime | ✅ | Data/hora da atividade |
| ip_address | String(45) | ❌ | IP do usuário |
| user_agent | Text | ❌ | Navegador/app usado |

#### 3.5 Menu: Avaliações de Performance
**CRUD:** avaliacoes_performance

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| usuario_avaliado_id | UUID | ✅ | FK para usuário avaliado |
| avaliador_id | UUID | ✅ | FK para quem avaliou |
| tipo_avaliacao | Enum | ✅ | professor, aluno, funcionario |
| periodo_inicio | Date | ✅ | Início do período avaliado |
| periodo_fim | Date | ✅ | Fim do período avaliado |
| criterios_avaliacao | JSON | ✅ | Critérios e notas |
| nota_geral | Decimal(3,2) | ✅ | Nota final (0-10) |
| pontos_fortes | Text | ❌ | Pontos positivos |
| pontos_melhorar | Text | ❌ | Pontos a melhorar |
| metas_futuras | Text | ❌ | Metas para próximo período |
| visivel_avaliado | Boolean | ✅ | Se o avaliado pode ver |
| data_avaliacao | Date | ✅ | Data da avaliação |

#### 3.6 Menu: Evolução dos Alunos
**CRUD:** evolucao_alunos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| aluno_id | UUID | ✅ | FK para aluno |
| professor_id | UUID | ✅ | FK para professor |
| data_avaliacao | Date | ✅ | Data da avaliação |
| nivel_anterior | Enum | ❌ | Nível antes da aula |
| nivel_atual | Enum | ✅ | Nível atual |
| habilidades_desenvolvidas | JSON | ✅ | Lista de habilidades |
| areas_melhorar | JSON | ❌ | Áreas que precisa melhorar |
| observacoes | Text | ❌ | Observações do professor |
| proximos_objetivos | Text | ❌ | Objetivos para próximas aulas |
| visivel_aluno | Boolean | ✅ | Se aluno pode ver |

**Operações CRUD:**
- ✅ Create: Cadastrar pessoas, atividades, avaliações
- ✅ Read: Listar e visualizar
- ✅ Update: Editar informações
- ✅ Delete: Inativar (não deletar)

---

### 📅 MÓDULO 4: AGENDAMENTOS

#### 4.1 Menu: Reservas de Quadra
**CRUD:** agendamentos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do agendamento |
| arena_id | UUID | ✅ | FK para arena |
| quadra_id | UUID | ✅ | FK para quadra |
| cliente_id | UUID | ✅ | FK para usuario (cliente) |
| tipo_agendamento | Enum | ✅ | avulso, aula, torneio, evento |
| data_agendamento | Date | ✅ | Data do agendamento |
| hora_inicio | Time | ✅ | Hora início |
| hora_fim | Time | ✅ | Hora fim |
| valor_total | Decimal(8,2) | ✅ | Valor total |
| valor_pago | Decimal(8,2) | ❌ | Valor já pago |
| status_pagamento | Enum | ✅ | pendente, pago, parcial, cancelado |
| forma_pagamento | Enum | ❌ | pix, cartao, dinheiro, credito |
| observacoes | Text | ❌ | Observações |
| participantes | JSON | ❌ | Lista de participantes |
| equipamentos_solicitados | JSON | ❌ | Equipamentos extras |
| status_agendamento | Enum | ✅ | confirmado, pendente, cancelado, realizado |
| confirmado_em | DateTime | ❌ | Data/hora confirmação |
| cancelado_em | DateTime | ❌ | Data/hora cancelamento |
| motivo_cancelamento | String(200) | ❌ | Motivo cancelamento |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 4.2 Menu: Check-ins
**CRUD:** checkins

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do check-in |
| agendamento_id | UUID | ✅ | FK para agendamento |
| usuario_id | UUID | ✅ | FK para usuario |
| tipo_checkin | Enum | ✅ | qrcode, geolocalizacao, manual, biometria |
| data_checkin | DateTime | ✅ | Data/hora do check-in |
| localizacao | Point | ❌ | Coordenadas (se geo) |
| dispositivo_info | JSON | ❌ | Info do dispositivo |
| responsavel_checkin | UUID | ❌ | Quem fez check-in manual |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | presente, ausente, atrasado |

#### 4.3 Menu: Lista de Espera
**CRUD:** lista_espera

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| quadra_id | UUID | ✅ | FK para quadra |
| cliente_id | UUID | ✅ | FK para cliente |
| data_desejada | Date | ✅ | Data que quer jogar |
| hora_inicio_desejada | Time | ✅ | Hora início desejada |
| hora_fim_desejada | Time | ✅ | Hora fim desejada |
| flexibilidade_horario | JSON | ❌ | Outros horários que aceita |
| data_solicitacao | DateTime | ✅ | Quando entrou na lista |
| prioridade | Integer | ✅ | Posição na lista |
| notificado | Boolean | ✅ | Se foi notificado sobre vaga |
| data_notificacao | DateTime | ❌ | Quando foi notificado |
| prazo_resposta | DateTime | ❌ | Até quando pode responder |
| aceite_automatico | Boolean | ✅ | Aceita vaga automaticamente |
| status | Enum | ✅ | aguardando, notificado, atendido, expirado |
| observacoes | Text | ❌ | Observações |

#### 4.4 Menu: Agendamentos Recorrentes
**CRUD:** agendamentos_recorrentes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| quadra_id | UUID | ✅ | FK para quadra |
| cliente_id | UUID | ✅ | FK para cliente |
| tipo_recorrencia | Enum | ✅ | semanal, quinzenal, mensal |
| dias_semana | JSON | ✅ | Dias da semana (para semanal) |
| hora_inicio | Time | ✅ | Hora início |
| hora_fim | Time | ✅ | Hora fim |
| data_inicio_periodo | Date | ✅ | Início da recorrência |
| data_fim_periodo | Date | ❌ | Fim da recorrência |
| valor_total_periodo | Decimal(8,2) | ✅ | Valor total do período |
| forma_pagamento | Enum | ✅ | Como vai pagar |
| status | Enum | ✅ | ativo, suspenso, cancelado |
| observacoes | Text | ❌ | Observações |

**Operações CRUD:**
- ✅ Create: Criar agendamentos, check-ins, lista de espera
- ✅ Read: Listar e visualizar
- ✅ Update: Editar agendamentos
- ✅ Delete: Cancelar agendamentos

---

### 🎓 MÓDULO 5: GESTÃO DE AULAS

#### 5.1 Menu: Tipos de Aula
**CRUD:** tipos_aula

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do tipo |
| arena_id | UUID | ✅ | FK para arena |
| nome | String(100) | ✅ | Nome do tipo de aula |
| modalidade | Enum | ✅ | beach_tennis, padel, tenis |
| nivel_exigido | Enum | ✅ | iniciante, intermediário, avançado |
| max_alunos | Integer | ✅ | Máximo de alunos |
| duracao_minutos | Integer | ✅ | Duração em minutos |
| valor_aula | Decimal(8,2) | ✅ | Valor por aula |
| descricao | Text | ❌ | Descrição da aula |
| equipamentos_necessarios | JSON | ❌ | Lista de equipamentos |
| status | Enum | ✅ | ativo, inativo |

#### 5.2 Menu: Aulas Agendadas
**CRUD:** aulas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da aula |
| arena_id | UUID | ✅ | FK para arena |
| tipo_aula_id | UUID | ✅ | FK para tipos_aula |
| professor_id | UUID | ✅ | FK para professor |
| quadra_id | UUID | ✅ | FK para quadra |
| data_aula | Date | ✅ | Data da aula |
| hora_inicio | Time | ✅ | Hora início |
| hora_fim | Time | ✅ | Hora fim |
| max_alunos | Integer | ✅ | Máximo de alunos |
| valor_total | Decimal(8,2) | ✅ | Valor total da aula |
| observacoes | Text | ❌ | Observações |
| material_aula | Text | ❌ | Material/conteúdo |
| status | Enum | ✅ | agendada, realizada, cancelada |
| avaliacao_professor | Integer | ❌ | Nota 1-5 |
| feedback_professor | Text | ❌ | Feedback do professor |

#### 5.3 Menu: Matrículas em Aulas
**CRUD:** matriculas_aulas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da matrícula |
| aula_id | UUID | ✅ | FK para aula |
| aluno_id | UUID | ✅ | FK para aluno |
| data_matricula | DateTime | ✅ | Data da matrícula |
| valor_pago | Decimal(8,2) | ✅ | Valor pago pelo aluno |
| status_pagamento | Enum | ✅ | pendente, pago, cancelado |
| presente | Boolean | ❌ | Compareceu à aula |
| data_checkin | DateTime | ❌ | Data/hora check-in |
| avaliacao_aula | Integer | ❌ | Nota 1-5 para aula |
| feedback_aluno | Text | ❌ | Feedback do aluno |
| status | Enum | ✅ | ativa, cancelada, transferida |

#### 5.4 Menu: Reposições
**CRUD:** reposicoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da reposição |
| matricula_original_id | UUID | ✅ | FK para matrícula original |
| aula_nova_id | UUID | ❌ | FK para nova aula (se já reagendou) |
| motivo_reposicao | Enum | ✅ | falta_aluno, falta_professor, clima, outro |
| data_solicitacao | DateTime | ✅ | Data da solicitação |
| prazo_limite | Date | ✅ | Prazo para usar reposição |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | pendente, agendada, utilizada, expirada |

#### 5.5 Menu: Planos de Aula
**CRUD:** planos_aula

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| professor_id | UUID | ✅ | FK para professor |
| tipo_aula_id | UUID | ✅ | FK para tipo de aula |
| titulo | String(150) | ✅ | Título do plano |
| objetivos | JSON | ✅ | Objetivos da aula |
| aquecimento | Text | ❌ | Atividades de aquecimento |
| parte_principal | Text | ✅ | Conteúdo principal |
| exercicios | JSON | ✅ | Lista de exercícios |
| materiais_necessarios | JSON | ❌ | Materiais e equipamentos |
| dificuldade | Enum | ✅ | iniciante, intermediário, avançado |
| duracao_estimada | Integer | ✅ | Duração em minutos |
| observacoes | Text | ❌ | Observações pedagógicas |
| status | Enum | ✅ | rascunho, aprovado, arquivado |
| data_criacao | Date | ✅ | Data de criação |
| usado_count | Integer | ✅ | Quantas vezes foi usado |

#### 5.6 Menu: Pacotes de Aulas
**CRUD:** pacotes_aulas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_pacote | String(100) | ✅ | Nome do pacote |
| tipo_aula_id | UUID | ✅ | FK para tipo de aula |
| quantidade_aulas | Integer | ✅ | Número de aulas incluídas |
| valor_total | Decimal(8,2) | ✅ | Valor total do pacote |
| valor_por_aula | Decimal(8,2) | ✅ | Valor unitário |
| desconto_percentual | Decimal(5,2) | ❌ | % de desconto |
| validade_dias | Integer | ✅ | Validade em dias |
| transferivel | Boolean | ✅ | Se pode transferir aulas |
| reembolsavel | Boolean | ✅ | Se pode reembolsar |
| descricao | Text | ❌ | Descrição do pacote |
| status | Enum | ✅ | ativo, inativo |

#### 5.7 Menu: Compra de Pacotes
**CRUD:** compras_pacotes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| pacote_id | UUID | ✅ | FK para pacote |
| aluno_id | UUID | ✅ | FK para aluno |
| data_compra | Date | ✅ | Data da compra |
| data_vencimento | Date | ✅ | Data de vencimento |
| aulas_restantes | Integer | ✅ | Aulas ainda disponíveis |
| valor_pago | Decimal(8,2) | ✅ | Valor efetivamente pago |
| forma_pagamento | Enum | ✅ | Como foi pago |
| status | Enum | ✅ | ativo, usado, vencido, cancelado |

**Operações CRUD:**
- ✅ Create: Criar tipos, aulas, matrículas, planos
- ✅ Read: Listar e visualizar
- ✅ Update: Editar informações
- ✅ Delete: Cancelar (não deletar)

---

### 💰 MÓDULO 6: GESTÃO FINANCEIRA

#### 6.1 Menu: Planos e Mensalidades
**CRUD:** planos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do plano |
| arena_id | UUID | ✅ | FK para arena |
| nome | String(100) | ✅ | Nome do plano |
| tipo_plano | Enum | ✅ | mensal, trimestral, semestral, anual |
| valor | Decimal(8,2) | ✅ | Valor do plano |
| beneficios | JSON | ✅ | Lista de benefícios |
| limitacoes | JSON | ❌ | Limitações do plano |
| descricao | Text | ❌ | Descrição detalhada |
| status | Enum | ✅ | ativo, inativo |

#### 6.2 Menu: Contratos/Assinaturas
**CRUD:** contratos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do contrato |
| arena_id | UUID | ✅ | FK para arena |
| cliente_id | UUID | ✅ | FK para cliente |
| plano_id | UUID | ✅ | FK para plano |
| data_inicio | Date | ✅ | Data início |
| data_fim | Date | ❌ | Data fim (se determinado) |
| valor_mensal | Decimal(8,2) | ✅ | Valor mensal |
| dia_vencimento | Integer | ✅ | Dia do vencimento (1-31) |
| forma_pagamento | Enum | ✅ | cartao_recorrente, boleto, pix |
| dados_pagamento | JSON | ❌ | Dados do cartão/conta |
| status | Enum | ✅ | ativo, suspenso, cancelado, inadimplente |
| observacoes | Text | ❌ | Observações |

#### 6.3 Menu: Faturas
**CRUD:** faturas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da fatura |
| arena_id | UUID | ✅ | FK para arena |
| cliente_id | UUID | ✅ | FK para cliente |
| contrato_id | UUID | ❌ | FK para contrato (se recorrente) |
| numero_fatura | String(20) | ✅ | Número sequencial |
| data_vencimento | Date | ✅ | Data vencimento |
| valor_original | Decimal(8,2) | ✅ | Valor original |
| valor_desconto | Decimal(8,2) | ❌ | Desconto aplicado |
| valor_acrescimo | Decimal(8,2) | ❌ | Juros/multa |
| valor_final | Decimal(8,2) | ✅ | Valor a pagar |
| data_pagamento | DateTime | ❌ | Data do pagamento |
| valor_pago | Decimal(8,2) | ❌ | Valor efetivamente pago |
| forma_pagamento | Enum | ❌ | Como foi pago |
| asaas_payment_id | String(50) | ❌ | ID no Asaas |
| status | Enum | ✅ | pendente, paga, vencida, cancelada |
| observacoes | Text | ❌ | Observações |

#### 6.4 Menu: Comissões de Professores
**CRUD:** comissoes_professores

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| professor_id | UUID | ✅ | FK para professor |
| arena_id | UUID | ✅ | FK para arena |
| periodo_inicio | Date | ✅ | Início do período |
| periodo_fim | Date | ✅ | Fim do período |
| total_aulas | Integer | ✅ | Total de aulas no período |
| valor_total_aulas | Decimal(8,2) | ✅ | Valor total das aulas |
| percentual_comissao | Decimal(5,2) | ✅ | % de comissão |
| valor_comissao | Decimal(8,2) | ✅ | Valor da comissão |
| descontos | Decimal(8,2) | ❌ | Descontos aplicados |
| valor_liquido | Decimal(8,2) | ✅ | Valor final a pagar |
| data_pagamento | Date | ❌ | Data do pagamento |
| forma_pagamento | Enum | ❌ | Como foi pago |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | calculada, paga, cancelada |

#### 6.5 Menu: Detalhes das Comissões
**CRUD:** detalhes_comissoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| comissao_id | UUID | ✅ | FK para comissao |
| aula_id | UUID | ✅ | FK para aula |
| data_aula | Date | ✅ | Data da aula |
| valor_aula | Decimal(8,2) | ✅ | Valor da aula |
| percentual_aplicado | Decimal(5,2) | ✅ | % aplicado nesta aula |
| valor_comissao_aula | Decimal(8,2) | ✅ | Comissão desta aula |
| observacoes | Text | ❌ | Observações |

#### 6.6 Menu: Movimentações Financeiras
**CRUD:** movimentacoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da movimentação |
| arena_id | UUID | ✅ | FK para arena |
| tipo_movimentacao | Enum | ✅ | receita, despesa |
| categoria | Enum | ✅ | mensalidade, aula_avulsa, manutencao, comissao, etc |
| descricao | String(200) | ✅ | Descrição |
| valor | Decimal(8,2) | ✅ | Valor |
| data_movimentacao | Date | ✅ | Data da movimentação |
| forma_pagamento | Enum | ❌ | Como foi pago/recebido |
| observacoes | Text | ❌ | Observações |
| fatura_id | UUID | ❌ | FK para fatura (se aplicável) |
| comissao_id | UUID | ❌ | FK para comissão (se aplicável) |
| responsavel_id | UUID | ❌ | Quem registrou |

#### 6.7 Menu: Formas de Pagamento
**CRUD:** formas_pagamento

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome | String(50) | ✅ | Nome da forma de pagamento |
| tipo | Enum | ✅ | dinheiro, pix, cartao_credito, cartao_debito, boleto |
| taxa_fixa | Decimal(8,2) | ❌ | Taxa fixa cobrada |
| taxa_percentual | Decimal(5,2) | ❌ | Taxa percentual |
| prazo_recebimento | Integer | ❌ | Dias para receber |
| ativa | Boolean | ✅ | Se está ativa |
| observacoes | Text | ❌ | Observações |

**Operações CRUD:**
- ✅ Create: Criar planos, contratos, faturas, comissões
- ✅ Read: Listar e visualizar
- ✅ Update: Editar informações
- ❌ Delete: Apenas cancelamento

---

### 🏆 MÓDULO 7: TORNEIOS E EVENTOS

#### 7.1 Menu: Torneios
**CRUD:** torneios

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único do torneio |
| arena_id | UUID | ✅ | FK para arena |
| nome | String(150) | ✅ | Nome do torneio |
| modalidade | Enum | ✅ | beach_tennis, padel, tenis |
| categoria | Enum | ✅ | iniciante, intermediário, avançado, mista |
| tipo_disputa | Enum | ✅ | simples, duplas, mista |
| data_inicio | Date | ✅ | Data início |
| data_fim | Date | ✅ | Data fim |
| data_limite_inscricao | Date | ✅ | Prazo inscrições |
| max_participantes | Integer | ✅ | Máximo participantes |
| valor_inscricao | Decimal(8,2) | ✅ | Valor da inscrição |
| premiacao | JSON | ❌ | Estrutura de premiação |
| regulamento | Text | ✅ | Regulamento completo |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | inscricoes_abertas, em_andamento, finalizado, cancelado |

#### 7.2 Menu: Inscrições em Torneios
**CRUD:** inscricoes_torneios

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da inscrição |
| torneio_id | UUID | ✅ | FK para torneio |
| jogador1_id | UUID | ✅ | FK para jogador 1 |
| jogador2_id | UUID | ❌ | FK para jogador 2 (duplas) |
| data_inscricao | DateTime | ✅ | Data da inscrição |
| valor_pago | Decimal(8,2) | ✅ | Valor pago |
| status_pagamento | Enum | ✅ | pendente, pago, cancelado |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | confirmada, pendente, cancelada |

#### 7.3 Menu: Chaveamento
**CRUD:** chaveamento

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| torneio_id | UUID | ✅ | FK para torneio |
| tipo_chave | Enum | ✅ | eliminatoria_simples, eliminatoria_dupla, round_robin |
| estrutura_chave | JSON | ✅ | Estrutura completa da chave |
| data_sorteio | DateTime | ✅ | Data do sorteio |
| criterio_sorteio | Enum | ✅ | aleatorio, ranking, seed |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | gerada, em_andamento, finalizada |

#### 7.4 Menu: Partidas do Torneio
**CRUD:** partidas_torneio

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| torneio_id | UUID | ✅ | FK para torneio |
| chaveamento_id | UUID | ✅ | FK para chaveamento |
| fase | Enum | ✅ | primeira_fase, oitavas, quartas, semi, final |
| rodada | Integer | ✅ | Número da rodada |
| inscricao1_id | UUID | ✅ | FK para inscrição 1 |
| inscricao2_id | UUID | ❌ | FK para inscrição 2 (pode ser bye) |
| quadra_id | UUID | ❌ | FK para quadra |
| data_agendada | DateTime | ❌ | Data/hora agendada |
| data_realizada | DateTime | ❌ | Data/hora realizada |
| placar | JSON | ❌ | Placar da partida |
| inscricao_vencedora_id | UUID | ❌ | FK para vencedor |
| observacoes | Text | ❌ | Observações |
| status | Enum | ✅ | agendada, em_andamento, finalizada, cancelada |

#### 7.5 Menu: Resultados e Rankings
**CRUD:** resultados_torneio

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| torneio_id | UUID | ✅ | FK para torneio |
| inscricao_id | UUID | ✅ | FK para inscrição |
| posicao_final | Integer | ✅ | Posição no torneio |
| pontos_conquistados | Integer | ❌ | Pontos para ranking |
| premiacao_recebida | Decimal(8,2) | ❌ | Valor da premiação |
| partidas_jogadas | Integer | ✅ | Total de partidas |
| vitorias | Integer | ✅ | Partidas vencidas |
| derrotas | Integer | ✅ | Partidas perdidas |
| sets_vencidos | Integer | ❌ | Sets vencidos |
| sets_perdidos | Integer | ❌ | Sets perdidos |
| games_vencidos | Integer | ❌ | Games vencidos |
| games_perdidos | Integer | ❌ | Games perdidos |

#### 7.6 Menu: Eventos Especiais
**CRUD:** eventos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_evento | String(150) | ✅ | Nome do evento |
| tipo_evento | Enum | ✅ | clinica, workshop, amistoso, confraternizacao |
| data_evento | Date | ✅ | Data do evento |
| hora_inicio | Time | ✅ | Hora início |
| hora_fim | Time | ✅ | Hora fim |
| max_participantes | Integer | ❌ | Máximo de participantes |
| valor_inscricao | Decimal(8,2) | ❌ | Valor da inscrição |
| descricao | Text | ✅ | Descrição do evento |
| material_incluso | JSON | ❌ | O que está incluso |
| responsavel_id | UUID | ❌ | Responsável pelo evento |
| quadras_utilizadas | JSON | ❌ | Quadras que serão usadas |
| status | Enum | ✅ | planejado, confirmado, realizado, cancelado |

#### 7.7 Menu: Participantes de Eventos
**CRUD:** participantes_eventos

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| evento_id | UUID | ✅ | FK para evento |
| participante_id | UUID | ✅ | FK para participante |
| data_inscricao | DateTime | ✅ | Data da inscrição |
| valor_pago | Decimal(8,2) | ❌ | Valor pago |
| presente | Boolean | ❌ | Compareceu ao evento |
| avaliacao | Integer | ❌ | Nota 1-5 para o evento |
| feedback | Text | ❌ | Feedback do participante |
| status | Enum | ✅ | inscrito, confirmado, cancelado |

**Operações CRUD:**
- ✅ Create: Criar torneios, inscrições, chaveamento, partidas
- ✅ Read: Listar e visualizar
- ✅ Update: Editar informações
- ✅ Delete: Cancelar

---

### 📊 MÓDULO 8: RELATÓRIOS E ANALYTICS

#### 8.1 Menu: Relatórios Super Admin (Consolidados)
**Apenas para Super Admin - Dados de todas as arenas:**

**8.1.1 Dashboard Global**
- Total de arenas ativas por plano
- Receita mensal do white-label
- Arenas em trial/vencidas/canceladas
- Uso por módulo/funcionalidade
- Métricas de engajamento por arena
- Churn rate e retenção
- Crescimento mês a mês

**8.1.2 Relatórios Financeiros Consolidados**
- Faturamento por arena e período
- Inadimplência por plano
- Lifetime Value (LTV) por arena
- Custo de aquisição de clientes (CAC)
- Margem de contribuição por plano

**8.1.3 Análises de Uso**
- Módulos mais/menos utilizados
- Funcionalidades com maior adoção
- Arenas com melhor performance
- Benchmarks por região/tamanho

#### 8.2 Menu: Dashboard Arena (Principal)
**Para Admin da Arena - Dados da arena específica:**

**8.2.1 Visão Geral Hoje**
- Agendamentos hoje
- Check-ins realizados
- Receita do dia
- Quadras ocupadas agora
- Próximos vencimentos
- Alertas importantes

**8.2.2 Métricas Semanais/Mensais**
- Taxa de ocupação por quadra
- Receita por modalidade
- Alunos ativos vs novos
- Performance de professores
- No-shows e cancelamentos

#### 8.3 Menu: Relatórios Operacionais
**CRUD:** relatorios_personalizados

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_relatorio | String(100) | ✅ | Nome do relatório |
| tipo_relatorio | Enum | ✅ | ocupacao, financeiro, frequencia, performance |
| filtros | JSON | ✅ | Filtros aplicados |
| colunas_visiveis | JSON | ✅ | Colunas a exibir |
| periodo_padrao | Enum | ✅ | hoje, semana, mes, trimestre, ano |
| frequencia_envio | Enum | ❌ | diario, semanal, mensal |
| emails_destinatarios | JSON | ❌ | Para quem enviar |
| visivel_para | JSON | ✅ | Quem pode ver (roles) |
| criado_por | UUID | ✅ | Quem criou |
| ativo | Boolean | ✅ | Se está ativo |
| created_at | Timestamp | ✅ | Data criação |

#### 8.4 Menu: Configurações de Visibilidade
**CRUD:** configuracoes_visibilidade

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| tipo_usuario | Enum | ✅ | professor, aluno, funcionario |
| secao_relatorio | Enum | ✅ | performance, financeiro, frequencia, ranking |
| visivel | Boolean | ✅ | Se pode ver |
| nivel_detalhe | Enum | ✅ | basico, completo, detalhado |
| campos_bloqueados | JSON | ❌ | Campos específicos bloqueados |
| observacoes | Text | ❌ | Justificativa |
| configurado_por | UUID | ✅ | Admin que configurou |
| data_configuracao | Date | ✅ | Data da configuração |

#### 8.5 Menu: Relatórios de Performance
**Para Professores (conforme visibilidade configurada):**

**8.5.1 Performance Individual Professor**
- Total de aulas ministradas
- Avaliação média dos alunos
- Taxa de presença nas aulas
- Evolução dos alunos
- Comissões recebidas
- Comparativo com outros professores (se liberado)

**8.5.2 Performance Individual Aluno**
- Frequência de presença
- Evolução de nível
- Aulas assistidas vs faltou
- Gastos totais
- Ranking interno (se liberado)
- Histórico de torneios

#### 8.6 Menu: Relatórios Financeiros Arena
**8.6.1 Receita e Despesas**
- Faturamento por período
- Receita por modalidade (avulso, mensalidade, aulas)
- Despesas por categoria
- Margem de lucro
- Comparativo periódico

**8.6.2 Inadimplência e Cobrança**
- Clientes em atraso
- Taxa de inadimplência
- Efetividade por forma de pagamento
- Histórico de recuperação

**8.6.3 Análise de Clientes**
- Lifetime Value por cliente
- Churn rate
- Ticket médio
- Clientes mais/menos ativos

#### 8.7 Menu: Relatórios de Uso e Ocupação
**8.7.1 Ocupação de Quadras**
- Taxa de ocupação por quadra/período
- Horários de maior/menor demanda
- Sazonalidade de uso
- Eficiência energética (horários iluminação)

**8.7.2 Check-ins e Presença**
- Taxa de presença por tipo de atividade
- No-shows por cliente/professor
- Pontualidade média
- Padrões de uso por dia/horário

#### 8.8 Menu: Logs de Sistema
**CRUD:** logs_sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ❌ | FK para arena (se aplicável) |
| usuario_id | UUID | ❌ | FK para usuário |
| acao | String(100) | ✅ | Ação realizada |
| modulo | String(50) | ✅ | Módulo afetado |
| detalhes | JSON | ❌ | Detalhes da ação |
| ip_address | String(45) | ❌ | IP do usuário |
| user_agent | Text | ❌ | Navegador usado |
| timestamp | Timestamp | ✅ | Data/hora |
| nivel_log | Enum | ✅ | info, warning, error, critical |

**Operações CRUD:**
- ✅ Create: Criar relatórios personalizados e configurações
- ✅ Read: Visualizar todos os relatórios
- ✅ Update: Editar configurações
- ✅ Delete: Remover relatórios personalizados

---

### ⚙️ MÓDULO 9: CONFIGURAÇÕES

#### 9.1 Menu: Módulos Ativos (Apenas Super Admin)
**CRUD:** modulos_arena

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| modulo_nome | Enum | ✅ | agendamentos, aulas, financeiro, torneios, etc |
| ativo | Boolean | ✅ | Se está ativo |
| data_ativacao | Date | ❌ | Quando foi ativado |
| data_desativacao | Date | ❌ | Quando foi desativado |
| motivo_desativacao | Text | ❌ | Por que foi desativado |
| configurado_por | UUID | ✅ | Super admin que configurou |
| observacoes | Text | ❌ | Observações |

#### 9.2 Menu: Configurações Gerais Arena
**CRUD:** configuracoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| categoria | Enum | ✅ | agendamento, financeiro, comunicacao, geral, seguranca |
| chave | String(100) | ✅ | Nome da configuração |
| valor | JSON | ✅ | Valor da configuração |
| tipo_campo | Enum | ✅ | texto, numero, boolean, lista, json |
| descricao | Text | ❌ | Descrição da config |
| editavel | Boolean | ✅ | Se pode ser editada |
| visivel_admin | Boolean | ✅ | Se admin da arena vê |
| updated_by | UUID | ❌ | Quem alterou por último |
| created_at | Timestamp | ✅ | Data criação |
| updated_at | Timestamp | ✅ | Última atualização |

#### 9.3 Menu: Integração WhatsApp
**CRUD:** integracao_whatsapp

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| api_key | String(200) | ✅ | Token Evolution API |
| webhook_url | String(255) | ✅ | URL do webhook |
| numero_whatsapp | String(15) | ✅ | Número do WhatsApp Business |
| nome_instancia | String(50) | ✅ | Nome da instância |
| status_conexao | Enum | ✅ | conectado, desconectado, erro |
| ultimo_teste | DateTime | ❌ | Último teste de conexão |
| templates_configurados | JSON | ❌ | Templates de mensagem |
| ativo | Boolean | ✅ | Se está ativo |
| observacoes | Text | ❌ | Observações |

#### 9.4 Menu: Templates WhatsApp
**CRUD:** templates_whatsapp

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_template | String(100) | ✅ | Nome do template |
| tipo_template | Enum | ✅ | confirmacao, lembrete, cancelamento, promocao |
| gatilho | Enum | ✅ | agendamento, 24h_antes, cancelamento, manual |
| mensagem | Text | ✅ | Texto da mensagem |
| variaveis | JSON | ❌ | Variáveis disponíveis |
| ativo | Boolean | ✅ | Se está ativo |
| enviados_count | Integer | ✅ | Quantas vezes foi enviado |
| created_at | Timestamp | ✅ | Data criação |

#### 9.5 Menu: Integração Asaas
**CRUD:** integracao_asaas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| api_key | String(200) | ✅ | API Key Asaas |
| webhook_url | String(255) | ✅ | URL do webhook |
| ambiente | Enum | ✅ | sandbox, producao |
| status_conexao | Enum | ✅ | conectado, desconectado, erro |
| ultimo_teste | DateTime | ❌ | Último teste |
| configuracoes_cobranca | JSON | ✅ | Configs de cobrança |
| taxa_personalizada | Decimal(5,2) | ❌ | Taxa negociada |
| ativo | Boolean | ✅ | Se está ativo |

#### 9.6 Menu: Automações n8n
**CRUD:** automacoes_n8n

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_automacao | String(100) | ✅ | Nome da automação |
| tipo_trigger | Enum | ✅ | novo_usuario, pagamento_vencido, lembrete_aula |
| webhook_url | String(255) | ✅ | URL do webhook n8n |
| workflow_id | String(50) | ❌ | ID do workflow no n8n |
| parametros | JSON | ❌ | Parâmetros da automação |
| ultima_execucao | DateTime | ❌ | Última execução |
| total_execucoes | Integer | ✅ | Total de execuções |
| ativo | Boolean | ✅ | Se está ativo |
| observacoes | Text | ❌ | Observações |

#### 9.7 Menu: Logs de Execução
**CRUD:** logs_execucao

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| automacao_id | UUID | ✅ | FK para automacao |
| data_execucao | DateTime | ✅ | Data/hora da execução |
| payload_enviado | JSON | ❌ | Dados enviados |
| resposta_recebida | JSON | ❌ | Resposta do webhook |
| status_execucao | Enum | ✅ | sucesso, erro, timeout |
| tempo_execucao | Integer | ❌ | Tempo em milissegundos |
| erro_detalhes | Text | ❌ | Detalhes do erro |

#### 9.8 Menu: Backup e Segurança
**CRUD:** configuracoes_backup

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| frequencia_backup | Enum | ✅ | diario, semanal, mensal |
| tipos_dados | JSON | ✅ | Que dados fazer backup |
| local_armazenamento | Enum | ✅ | supabase, s3, google_drive |
| retencao_dias | Integer | ✅ | Por quantos dias manter |
| ultimo_backup | DateTime | ❌ | Último backup realizado |
| proximo_backup | DateTime | ✅ | Próximo backup agendado |
| ativo | Boolean | ✅ | Se está ativo |

#### 9.9 Menu: Notificações Push
**CRUD:** configuracoes_push

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| tipo_notificacao | Enum | ✅ | agendamento, pagamento, lembrete, promocao |
| titulo_padrao | String(100) | ✅ | Título padrão |
| mensagem_padrao | Text | ✅ | Mensagem padrão |
| ativo | Boolean | ✅ | Se está ativo |
| usuarios_alvo | JSON | ❌ | Tipos de usuário que recebem |
| horario_envio | JSON | ❌ | Restrições de horário |

**Operações CRUD:**
- ✅ Create: Criar configurações e integrações
- ✅ Read: Visualizar configurações
- ✅ Update: Editar configurações  
- ✅ Delete: Desativar configurações

---

### 🔐 MÓDULO 10: AUTENTICAÇÃO E PERMISSÕES

#### 10.1 Menu: Usuários e Permissões
**CRUD:** permissoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único da permissão |
| usuario_id | UUID | ✅ | FK para usuario |
| modulo | String(50) | ✅ | Nome do módulo |
| acao | Enum | ✅ | create, read, update, delete |
| permitido | Boolean | ✅ | Se tem permissão |
| data_concessao | Date | ✅ | Quando foi concedida |
| concedida_por | UUID | ✅ | Quem concedeu |

#### 10.2 Menu: Sessões Ativas
**CRUD:** sessoes_usuario

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| usuario_id | UUID | ✅ | FK para usuario |
| token_sessao | String(255) | ✅ | Token da sessão |
| ip_address | String(45) | ✅ | IP de origem |
| user_agent | Text | ✅ | Navegador/dispositivo |
| data_login | DateTime | ✅ | Data/hora do login |
| data_ultima_atividade | DateTime | ✅ | Última atividade |
| data_expiracao | DateTime | ✅ | Expiração da sessão |
| ativa | Boolean | ✅ | Se ainda está ativa |
| tipo_dispositivo | Enum | ✅ | web, mobile, tablet |

**Operações CRUD:**
- ✅ Create: Criar permissões e sessões
- ✅ Read: Listar permissões e sessões
- ✅ Update: Editar permissões
- ✅ Delete: Revogar permissões e encerrar sessões

---

### 📢 MÓDULO 11: NOTIFICAÇÕES E COMUNICAÇÃO

#### 11.1 Menu: Central de Notificações
**CRUD:** notificacoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| usuario_destinatario_id | UUID | ✅ | Para quem é a notificação |
| tipo_notificacao | Enum | ✅ | sistema, agendamento, pagamento, promocao |
| titulo | String(150) | ✅ | Título da notificação |
| mensagem | Text | ✅ | Conteúdo da notificação |
| dados_extras | JSON | ❌ | Dados adicionais |
| canal_envio | Enum | ✅ | app, email, whatsapp, sms |
| prioridade | Enum | ✅ | baixa, media, alta, urgente |
| agendada_para | DateTime | ❌ | Se foi agendada |
| enviada_em | DateTime | ❌ | Quando foi enviada |
| lida_em | DateTime | ❌ | Quando foi lida |
| acao_executada | Boolean | ✅ | Se clicou no botão de ação |
| status | Enum | ✅ | pendente, enviada, lida, erro |

#### 11.2 Menu: Campanhas de Marketing
**CRUD:** campanhas

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| nome_campanha | String(100) | ✅ | Nome da campanha |
| tipo_campanha | Enum | ✅ | promocional, retencao, aniversario, reativacao |
| publico_alvo | JSON | ✅ | Critérios do público |
| canais_envio | JSON | ✅ | WhatsApp, email, push, etc |
| conteudo_mensagem | Text | ✅ | Conteúdo principal |
| data_inicio | DateTime | ✅ | Início da campanha |
| data_fim | DateTime | ❌ | Fim da campanha |
| total_destinatarios | Integer | ✅ | Quantos vão receber |
| enviados | Integer | ✅ | Quantos foram enviados |
| abertos | Integer | ✅ | Quantos abriram |
| cliques | Integer | ✅ | Quantos clicaram |
| conversoes | Integer | ✅ | Quantos converteram |
| status | Enum | ✅ | rascunho, agendada, enviando, concluida |

#### 11.3 Menu: Histórico de Comunicações
**CRUD:** historico_comunicacoes

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| usuario_id | UUID | ✅ | FK para usuário |
| tipo_comunicacao | Enum | ✅ | whatsapp, email, sms, push, ligacao |
| assunto | String(200) | ✅ | Assunto/título |
| conteudo | Text | ✅ | Conteúdo da comunicação |
| remetente | String(100) | ✅ | Quem enviou |
| data_envio | DateTime | ✅ | Data/hora envio |
| data_entrega | DateTime | ❌ | Quando foi entregue |
| data_leitura | DateTime | ❌ | Quando foi lida |
| status_entrega | Enum | ✅ | enviado, entregue, lido, erro |
| anexos | JSON | ❌ | Arquivos anexados |

**Operações CRUD:**
- ✅ Create: Criar notificações, campanhas
- ✅ Read: Listar comunicações
- ✅ Update: Editar campanhas
- ✅ Delete: Cancelar campanhas agendadas

---

### 📋 MÓDULO 12: AUDITORIA E LOGS

#### 12.1 Menu: Logs de Sistema
**CRUD:** logs_sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ❌ | FK para arena (se aplicável) |
| usuario_id | UUID | ❌ | FK para usuário |
| acao | String(100) | ✅ | Ação realizada |
| modulo | String(50) | ✅ | Módulo afetado |
| tabela_afetada | String(50) | ❌ | Tabela modificada |
| registro_id | UUID | ❌ | ID do registro afetado |
| valores_anteriores | JSON | ❌ | Estado anterior |
| valores_novos | JSON | ❌ | Estado novo |
| ip_address | String(45) | ❌ | IP do usuário |
| user_agent | Text | ❌ | Navegador usado |
| timestamp | Timestamp | ✅ | Data/hora |
| nivel_log | Enum | ✅ | info, warning, error, critical |

#### 12.2 Menu: Auditoria de Dados
**CRUD:** auditoria_dados

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | ✅ | ID único |
| arena_id | UUID | ✅ | FK para arena |
| tabela | String(50) | ✅ | Tabela auditada |
| operacao | Enum | ✅ | insert, update, delete |
| registro_id | UUID | ✅ | ID do registro |
| usuario_responsavel | UUID | ✅ | Quem fez a alteração |
| dados_anteriores | JSON | ❌ | Estado anterior |
| dados_novos | JSON | ✅ | Estado novo |
| timestamp | Timestamp | ✅ | Data/hora |
| origem | Enum | ✅ | web, mobile, api, sistema |

**Operações CRUD:**
- ✅ Create: Logs são criados automaticamente
- ✅ Read: Consultar logs e auditoria
- ❌ Update: Logs não são editáveis
- ❌ Delete: Logs não são deletáveis (apenas arquivamento)

---

## INTEGRAÇÕES E WEBHOOKS

### WhatsApp (Evolution API)
- **Webhook Entrada:** `/webhook/whatsapp/incoming`
- **Webhook Saída:** `/webhook/whatsapp/outgoing`
- **Eventos:** message_received, message_sent, status_update

### Asaas (Pagamentos)
- **Webhook:** `/webhook/asaas/payment`
- **Eventos:** payment_created, payment_confirmed, payment_overdue

### n8n (Automações)
- **Triggers:**
  - `/trigger/new-user`
  - `/trigger/payment-overdue`
  - `/trigger/class-reminder`
  - `/trigger/weather-alert`
  - `/trigger/tournament-update`
  - `/trigger/performance-report`

---

## ESTATÍSTICAS DA ESTRUTURA COMPLETA

### **📊 RESUMO GERAL:**
- **12 Módulos Principais** (0-12)
- **50+ Tabelas/CRUDs** mapeados
- **300+ Campos** estruturados
- **Multi-tenant** com controle granular
- **3 Níveis de relatórios** (Super Admin, Arena, Usuários)

### **🎯 DIFERENCIAIS ÚNICOS:**
- **Controle de módulos por plano** (Super Admin)
- **Relatórios configuráveis** por tipo de usuário
- **Check-in inteligente** (4 modalidades)
- **WhatsApp nativo** integrado
- **Gestão específica** por modalidade esportiva
- **Sistema de reposições** automatizado
- **Comissões automáticas** para professores
- **Auditoria completa** de todas as ações

### **🔧 STACK TECNOLÓGICO CONFIRMADO:**
- **Backend:** Supabase (PostgreSQL + APIs + Auth + Storage)
- **Frontend Web:** Next.js 14 + TypeScript + Tailwind CSS
- **Mobile:** React Native + Expo
- **Automações:** n8n self-hosted
- **WhatsApp:** Evolution API
- **Pagamentos:** Asaas
- **Deploy:** Vercel + Supabase Cloud
- **Monitoramento:** Sentry + PostHog

---

## PRÓXIMOS PASSOS - ROADMAP DE DESENVOLVIMENTO

### **FASE 1: MVP CORE (2-3 meses)**
**Módulos Essenciais:**
- Módulo 0: Super Admin (planos, controle de módulos)
- Módulo 1: Gestão de Arenas (básico)
- Módulo 2: Gestão de Quadras (básico)
- Módulo 3: Gestão de Pessoas (usuários, alunos, professores)
- Módulo 4: Agendamentos (reservas, check-ins básicos)
- Módulo 10: Autenticação e Permissões
- Módulo 8: Relatórios (dashboard básico)

**Deliverables:**
- Sistema multi-tenant funcional
- CRUD completo dos módulos core
- Autenticação robusta
- Dashboard básico operacional

### **FASE 2: FINANCEIRO E PAGAMENTOS (1-2 meses)**
**Módulos Adicionados:**
- Módulo 6: Gestão Financeira (completo)
- Integração Asaas (cobrança automática)
- Módulo 8: Relatórios Financeiros

**Deliverables:**
- Cobrança recorrente funcional
- Controle de inadimplência
- Relatórios financeiros completos
- Split de pagamentos para professores

### **FASE 3: COMUNICAÇÃO E AUTOMAÇÃO (1-2 meses)**
**Módulos Adicionados:**
- Módulo 9: Integração WhatsApp Evolution
- Módulo 11: Notificações e Comunicação
- Módulo 9: Automações n8n (básicas)

**Deliverables:**
- WhatsApp integrado nativamente
- Sistema de notificações completo
- Automações básicas funcionando
- Templates de mensagem

### **FASE 4: AULAS E EDUCAÇÃO (1-2 meses)**
**Módulos Adicionados:**
- Módulo 5: Gestão de Aulas (completo)
- Sistema de reposições avançado
- Avaliações e evolução de alunos
- Planos de aula

**Deliverables:**
- Gestão completa de aulas
- Check-ins inteligentes
- Sistema de reposições automatizado
- Tracking de evolução dos alunos

### **FASE 5: TORNEIOS E EVENTOS (1-2 meses)**
**Módulos Adicionados:**
- Módulo 7: Torneios e Eventos (completo)
- Chaveamento automatizado
- Gestão de resultados

**Deliverables:**
- Sistema completo de torneios
- Chaveamento automático
- Rankings e estatísticas
- Eventos especiais

### **FASE 6: ANALYTICS E OTIMIZAÇÃO (1 mês)**
**Módulos Finalizados:**
- Módulo 8: Relatórios Avançados (completo)
- Módulo 12: Auditoria e Logs
- Otimizações de performance

**Deliverables:**
- Relatórios avançados e personalizáveis
- Sistema de auditoria completo
- Performance otimizada
- Logs detalhados

### **FASE 7: FEATURES AVANÇADAS (Futuro)**
**Funcionalidades Premium:**
- IA para otimização de horários
- Integração com wearables
- Computer vision para análise de jogos
- Sistema de ranking nacional
- API pública para integrações

---

## ESTIMATIVAS DE DESENVOLVIMENTO

### **Recursos Necessários:**
- **1 Desenvolvedor Full-Stack** (React/Next.js + Supabase)
- **1 Desenvolvedor Mobile** (React Native - a partir da Fase 2)
- **1 Designer UI/UX** (part-time)
- **1 Product Manager** (você)

### **Timeline Total: 8-12 meses**
- **MVP funcional:** 3 meses
- **Versão comercial:** 6 meses  
- **Versão completa:** 12 meses

### **Custos Estimados (Mensal):**
- **Desenvolvimento:** R$ 25.000-35.000/mês
- **Infraestrutura:** R$ 2.000-5.000/mês
- **Ferramentas/Licenças:** R$ 1.000/mês
- **Total:** R$ 28.000-41.000/mês

---

**Status:** ✅ Estrutura completa revisada - Todos os CRUDs mapeados  
**Próxima Etapa:** Definir schemas SQL do Supabase para Fase 1
**Versão:** 1.1.0 - Revisão completa com controle de módulos e relatórios configuráveis