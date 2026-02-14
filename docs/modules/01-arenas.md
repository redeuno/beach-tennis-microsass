# Modulo 1: Gestao de Arenas

[<- Voltar aos Modulos](./README.md)

---

## Descricao

Cadastro, configuracao e customizacao visual da arena. Ponto central que conecta todos os outros modulos.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Cadastro da Arena | Nome, CNPJ, endereco, contatos |
| Customizacao Visual | Logo, cores do tema (white-label) |
| Horario de Funcionamento | Configuracao de dias e horarios |
| Politicas de Negocio | Cancelamento, reposicao, descontos |
| Configuracoes Operacionais | Parametros gerais de operacao |

## Tabelas Relacionadas

- `arenas` - Dados principais da arena
- `configuracoes_arena` - Configuracoes por categoria
- `politicas_negocio` - Regras de negocio

## Permissoes

| Role | Acesso |
|------|--------|
| super_admin | CRUD completo |
| arena_admin | Leitura + Edicao da propria arena |
| funcionario | Somente leitura |

## Rota

```
app/(dashboard)/arenas/
```
