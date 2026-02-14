# Modulo 2: Gestao de Quadras

[<- Voltar aos Modulos](./README.md)

---

## Descricao

Cadastro e controle de quadras, incluindo bloqueios, manutencoes e gestao de equipamentos.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Cadastro de Quadras | Nome, esporte, piso, cobertura, iluminacao |
| Precificacao | Valor hora pico vs normal, horarios de pico |
| Bloqueios | Bloqueio temporario para manutencao/eventos |
| Manutencoes | Historico e agendamento de manutencoes |
| Equipamentos | Equipamentos inclusos por quadra |

## Tabelas Relacionadas

- `quadras` - Dados das quadras
- `quadras_bloqueios` - Bloqueios ativos
- `manutencoes` - Historico de manutencoes

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Leitura + Bloqueios |
| professor | Somente leitura |
| aluno | Somente leitura (disponibilidade) |

## Rota

```
app/(dashboard)/quadras/
```
