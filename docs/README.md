# Documentacao - Verana Beach Tennis

Hub central de toda a documentacao do projeto.

---

## Indice

### [Arquitetura](./architecture/)
Visao geral do sistema, decisoes tecnicas e estrutura de pastas.

- [Visao Geral do Sistema](./architecture/system-overview.md) - Arquitetura multi-tenant, componentes principais
- [Stack Tecnologica](./architecture/tech-stack.md) - Decisoes de tecnologia e justificativas

### [Banco de Dados](./database/)
Schemas SQL completos, seguranca e configuracoes do Supabase.

- [Schemas SQL](./database/schemas.md) - Todas as tabelas, ENUMs e constraints
- [Seguranca e RLS](./database/rls-and-security.md) - Politicas RLS, triggers, indices e seeds

### [Modulos Funcionais](./modules/)
Documentacao detalhada de cada modulo do sistema.

- [M0 - Super Admin](./modules/00-super-admin.md) - Gestao white-label
- [M1 - Arenas](./modules/01-arenas.md) - Gestao de arenas
- [M2 - Quadras](./modules/02-quadras.md) - Gestao de quadras
- [M3 - Pessoas](./modules/03-pessoas.md) - Gestao de usuarios
- [M4 - Agendamentos](./modules/04-agendamentos.md) - Sistema de reservas
- [M5 - Aulas](./modules/05-aulas.md) - Gestao de aulas
- [M6 - Financeiro](./modules/06-financeiro.md) - Gestao financeira
- [M7 - Torneios e Eventos](./modules/07-torneios-eventos.md) - Torneios e eventos

### [Interface e UI](./ui/)
Design system, wireframes e componentes padronizados.

- [Design System](./ui/design-system.md) - Cores, componentes, padroes visuais
- [Wireframes](./ui/wireframes.md) - Wireframes das telas principais

### [Integracoes](./integrations/)
Documentacao das APIs e servicos externos.

- [WhatsApp - Evolution API](./integrations/whatsapp.md) - Mensagens, templates, automacoes
- [Asaas - Pagamentos](./integrations/asaas.md) - Cobrancas, faturas, PIX
- [Automacoes - n8n](./integrations/automations.md) - Workflows automatizados

### [Guias](./guides/)
Guias praticos para implementacao e operacao.

- [Getting Started](./guides/getting-started.md) - Setup do ambiente
- [Sequencia de Implementacao](./guides/implementation-sequence.md) - Ordem de desenvolvimento
- [Deploy](./guides/deployment.md) - Publicacao em producao

---

## Documentos Legados

Os documentos originais consolidados estao arquivados em [`../11-beach-tennis-microsass/`](../11-beach-tennis-microsass/):

| Arquivo | Descricao |
|---------|-----------|
| `current/verana-beach-tennis-completo.md` | Documento principal consolidado v1.1 |
| `current/verana-database-schemas.md` | Schemas SQL completos v1.0 |
| `current/verana-prompts-lovable-completo.md` | Prompts 0-7 para Lovable |
| `current/prompts-8-10.md` | Prompts 8-10 complementares |
| `docs-analysis/` | 7 documentos fonte originais |
| `versions/` | Historico de versoes (v1.0, v1.1) |

---

*Ultima atualizacao: 14/02/2026*
