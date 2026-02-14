# Modulo 5: Gestao de Aulas

[<- Voltar aos Modulos](./README.md)

**Plano minimo:** Pro

---

## Descricao

Sistema completo de gestao de aulas incluindo tipos, matriculas, pacotes, presenca e reposicoes.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Tipos de Aula | Individual, grupo, clinica, por nivel |
| Agendamento de Aulas | Vinculado ao agendamento de quadra |
| Matriculas e Pacotes | Pacotes de aulas com desconto |
| Controle de Presenca | Check-in multi-metodo por aula |
| Plano de Aula | Objetivos, conteudo, material |
| Reposicoes | Sistema de reposicao com motivo |
| Avaliacao | Feedback professor <-> alunos |

## Tabelas Relacionadas

- `aulas` - Aulas agendadas/realizadas
- `tipos_aula` - Tipos de aula disponiveis
- `pacotes_aulas` - Pacotes com desconto

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Leitura + criacao |
| professor | CRUD das proprias aulas, presenca, avaliacao |
| aluno | Visualizar aulas, fazer check-in |

## Rota

```
app/(dashboard)/aulas/
```
