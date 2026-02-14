# Modulo 7: Torneios e Eventos

[<- Voltar aos Modulos](./README.md)

**Plano minimo:** Premium

---

## Descricao

Organizacao de torneios com inscricoes, chaveamento automatico, ranking e eventos especiais.

## Funcionalidades

### Torneios
| Funcionalidade | Descricao |
|----------------|-----------|
| Criacao de Torneio | Nome, modalidade, datas, regras |
| Inscricoes | Individual ou duplas, pagamento |
| Chaveamento | Eliminacao simples/dupla, grupos |
| Categorias | Por nivel, idade, genero |
| Premiacao | Distribuicao configuravel |
| Ranking | Pontuacao e classificacao |

### Eventos Especiais
| Funcionalidade | Descricao |
|----------------|-----------|
| Workshop | Clinicas e treinamentos especiais |
| Festa | Eventos sociais na arena |
| Corporativo | Eventos empresariais |
| Promocional | Acoes de marketing |

## Tabelas Relacionadas

- `torneios` - Dados do torneio
- `inscricoes_torneios` - Participantes
- `eventos` - Eventos especiais

## Status do Torneio

| Status | Descricao |
|--------|-----------|
| `planejado` | Em preparacao |
| `divulgado` | Aberto para inscricoes |
| `aberto` | Em andamento |
| `realizado` | Concluido |
| `cancelado` | Cancelado |

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Gestao operacional |
| professor | Consulta |
| aluno | Inscricao e visualizacao |

## Rota

```
app/(dashboard)/torneios/
```
