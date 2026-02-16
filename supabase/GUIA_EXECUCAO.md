# Guia de Execucao - Banco de Dados Verana Beach Tennis

## Para quem e este guia

Este guia foi feito para voce que **NAO e desenvolvedor** e precisa executar os scripts SQL no Supabase para criar o banco de dados completo do sistema.

---

## O que voce vai precisar

1. **Uma conta no Supabase** (gratis para comecar): https://supabase.com
2. **Um navegador web** (Chrome, Firefox, etc.)
3. **Os arquivos SQL** que estao na pasta `supabase/migrations/` deste repositorio

---

## Passo a Passo Completo

### PASSO 1: Criar um projeto no Supabase

1. Acesse https://supabase.com e faca login (pode usar conta Google ou GitHub)
2. Clique em **"New Project"**
3. Preencha:
   - **Name**: `verana-beach-tennis` (ou o nome que preferir)
   - **Database Password**: Crie uma senha forte e **GUARDE EM LUGAR SEGURO**
   - **Region**: Escolha `South America (Sao Paulo)` se disponivel, ou a mais proxima
4. Clique em **"Create new project"**
5. Aguarde 2-3 minutos ate o projeto ser criado

### PASSO 2: Abrir o SQL Editor

1. No painel do Supabase, olhe o menu lateral esquerdo
2. Clique em **"SQL Editor"** (icone de codigo `<>`)
3. Voce vera uma tela com um campo grande para digitar SQL

### PASSO 3: Executar os arquivos na ORDEM CORRETA

**IMPORTANTE: Voce DEVE executar os arquivos na ordem numerica (001, 002, 003... ate 020). NAO pule nenhum arquivo e NAO mude a ordem.**

Para CADA arquivo, faca:

1. Abra o arquivo no seu computador (pode usar o Bloco de Notas, VS Code, ou qualquer editor de texto)
2. Selecione TODO o conteudo do arquivo (Ctrl+A)
3. Copie (Ctrl+C)
4. No SQL Editor do Supabase, cole (Ctrl+V)
5. Clique no botao **"Run"** (botao verde no canto inferior direito, ou Ctrl+Enter)
6. **Aguarde** ate aparecer uma mensagem de sucesso (verde)
7. Se der erro (vermelho), **NAO prossiga** - veja a secao de Problemas Comuns abaixo
8. **Apague** o conteudo do editor antes de colar o proximo arquivo

### Ordem dos Arquivos:

| # | Arquivo | O que faz |
|---|---------|-----------|
| 1 | `001_extensions_and_config.sql` | Configura extensoes e timezone |
| 2 | `002_enums.sql` | Cria os tipos de dados (65 tipos) |
| 3 | `003_platform_tables.sql` | Cria tabelas da plataforma (planos, arenas) |
| 4 | `004_users_tables.sql` | Cria tabelas de usuarios |
| 5 | `005_courts_tables.sql` | Cria tabelas de quadras |
| 6 | `006_scheduling_tables.sql` | Cria tabelas de agendamentos |
| 7 | `007_classes_tables.sql` | Cria tabelas de aulas |
| 8 | `008_financial_tables.sql` | Cria tabelas financeiras |
| 9 | `009_tournaments_tables.sql` | Cria tabelas de torneios |
| 10 | `010_communication_tables.sql` | Cria tabelas de comunicacao |
| 11 | `011_config_and_audit_tables.sql` | Cria tabelas de configuracao e auditoria |
| 12 | `012_rls_policies.sql` | Configura seguranca (RLS) |
| 13 | `013_triggers_and_functions.sql` | Cria funcoes automaticas |
| 14 | `014_indexes.sql` | Cria indices para performance |
| 15 | `015_views.sql` | Cria views para relatorios |
| 16 | `016_seeds.sql` | Insere dados iniciais |
| 17 | `017_platform_enhancements.sql` | Multi-arena, trial, metricas, webhooks |
| 18 | `018_platform_rls_triggers_indexes.sql` | Seguranca e indices para tabelas novas |
| 19 | `019_edge_functions_support.sql` | Edge Functions, fila de mensagens, chatbot AI, insights |
| 20 | `020_edge_functions_rls_triggers_indexes.sql` | Seguranca e indices para tabelas de automacao |

### PASSO 4: Verificar se tudo foi criado corretamente

Apos executar TODOS os 20 arquivos, execute este SQL no editor para verificar:

```sql
-- Conta quantas tabelas foram criadas (esperado: 76)
SELECT COUNT(*) as total_tabelas
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE';

-- Lista todas as tabelas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Verifica se RLS esta habilitado (todas devem ter rowsecurity = true)
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- Verifica triggers criados
SELECT trigger_name, event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table;

-- Verifica ENUMs criados (esperado: 69)
SELECT typname FROM pg_type
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public')
AND typtype = 'e' ORDER BY typname;
```

### PASSO 5: Salvar suas credenciais

Apos criar o projeto, voce vai precisar dessas informacoes para conectar o frontend:

1. No Supabase, va em **Settings** (engrenagem no menu lateral)
2. Clique em **API**
3. Copie e guarde:
   - **Project URL** (ex: `https://xyzabc.supabase.co`)
   - **anon public** key (chave publica)
   - **service_role** key (chave secreta - **NUNCA compartilhe!**)

Crie um arquivo `.env.local` na raiz do projeto Next.js com:

```
NEXT_PUBLIC_SUPABASE_URL=sua_url_aqui
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua_anon_key_aqui
SUPABASE_SERVICE_ROLE_KEY=sua_service_role_key_aqui
```

---

## Problemas Comuns e Solucoes

### Erro: "type already exists"
**Causa**: Voce ja executou esse arquivo antes.
**Solucao**: Se voce quer recriar do zero, va em **SQL Editor** e execute:
```sql
-- CUIDADO: isso apaga TUDO. So faca se quer recriar do zero.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```
Depois execute todos os arquivos novamente desde o 001.

### Erro: "relation does not exist"
**Causa**: Voce pulou algum arquivo ou executou fora de ordem.
**Solucao**: Execute os arquivos na ordem correta desde o inicio.

### Erro: "permission denied"
**Causa**: Voce esta usando a chave `anon` ao inves da `service_role`.
**Solucao**: Use o SQL Editor do Dashboard do Supabase, que ja tem permissoes de admin.

### Erro: "extension not available"
**Causa**: A extensao PostGIS pode nao estar disponivel no plano Free.
**Solucao**: Voce pode comentar a linha `CREATE EXTENSION IF NOT EXISTS "postgis";` no arquivo 001. O sistema funciona sem GPS, so nao tera check-in por geolocalizacao.

### Erro: "database quota exceeded"
**Causa**: O plano Free do Supabase tem limite de 500MB.
**Solucao**: Apague dados de teste ou considere fazer upgrade do plano.

---

## Estrutura do Banco de Dados

Apos a execucao, voce tera:

- **76 tabelas** cobrindo todos os modulos do sistema
- **69 tipos ENUM** para padronizacao de dados
- **Seguranca RLS** ativa em todas as tabelas (isolamento por arena)
- **~120 policies** de seguranca granulares por papel
- **5 views** para relatorios automaticos
- **Triggers** para auditoria e numeracao automatica de faturas
- **Dados iniciais**: 3 planos, 11 modulos, 5 relatorios, 7 cron jobs, configuracoes padrao
- **Fila de mensagens** para WhatsApp com rate limiting
- **Tabelas de chatbot AI** para atendimento automatico via WhatsApp
- **Tabelas de insights** para analises automaticas por arena

### Tabelas por Modulo:

| Modulo | Tabelas |
|--------|---------|
| Plataforma | planos_sistema, modulos_sistema, arenas, arenas_planos, faturas_sistema, arena_modulos, relatorios_sistema, arena_relatorios_config, **usuarios_arenas**, **eventos_assinatura**, **webhook_events**, **uso_plataforma**, **anuncios_plataforma**, **anuncios_lidos**, **metricas_plataforma** |
| Usuarios | usuarios, professores, funcionarios, permissoes |
| Quadras | quadras, quadras_bloqueios, manutencoes, equipamentos_quadra |
| Agendamentos | agendamentos, checkins, lista_espera, agendamentos_recorrentes |
| Aulas | tipos_aula, aulas, matriculas_aulas, reposicoes, planos_aula, pacotes_aulas, compras_pacotes |
| Financeiro | planos, contratos, faturas, comissoes_professores, detalhes_comissoes, movimentacoes, formas_pagamento |
| Torneios | torneios, inscricoes_torneios, chaveamento, partidas_torneio, resultados_torneio, eventos, participantes_eventos |
| Comunicacao | notificacoes, campanhas, historico_comunicacoes, templates_comunicacao, templates_whatsapp, integracao_whatsapp, integracao_asaas, automacoes, logs_execucao, configuracoes_backup, configuracoes_push, **fila_mensagens**, **chatbot_conversas**, **chatbot_mensagens**, **insights_arena**, **cron_jobs_config** |
| Config | configuracoes_arena, politicas_negocio, modulos_arena, sessoes_usuario, historico_atividades, avaliacoes_performance, evolucao_alunos, relatorios_personalizados, configuracoes_visibilidade, logs_sistema, auditoria_dados, configuracoes |

---

## Proximo Passo

Apos o banco de dados estar criado, o proximo passo e criar o projeto Next.js e conecta-lo ao Supabase. Veja o guia em `docs/guides/getting-started.md`.

---

**Duvidas?** Abra uma issue no repositorio ou entre em contato com o desenvolvedor.
