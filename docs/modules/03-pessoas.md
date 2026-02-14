# Modulo 3: Gestao de Pessoas

[<- Voltar aos Modulos](./README.md)

---

## Descricao

Cadastro e gestao de todos os usuarios da arena: alunos, professores, funcionarios e administradores.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Cadastro de Usuarios | Dados pessoais, contato, documentos |
| Perfil do Jogador | Nivel, dominancia, posicao preferida |
| Gestao de Professores | Especialidades, comissao, disponibilidade |
| Gestao de Funcionarios | Cargo, permissoes, horario |
| Historico de Atividades | Log de acoes por usuario |

## Tabelas Relacionadas

- `usuarios` - Dados de todos os usuarios
- `professores` - Extensao para professores
- `funcionarios` - Extensao para funcionarios
- `historico_atividades` - Log de atividades

## Tipos de Usuario

| Tipo | Campos Especificos |
|------|-------------------|
| aluno | nivel_jogo, dominancia, posicao_preferida, observacoes_medicas |
| professor | especialidades, valor_hora, comissao, disponibilidade, certificacoes |
| funcionario | cargo, salario, permissoes, horario_trabalho |
| arena_admin | Acesso total aos modulos do plano |

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Leitura + Cadastro de alunos |
| professor | Leitura dos proprios alunos |
| aluno | Somente proprio perfil |

## Rota

```
app/(dashboard)/pessoas/
```
