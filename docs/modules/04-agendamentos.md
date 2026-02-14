# Modulo 4: Agendamentos

[<- Voltar aos Modulos](./README.md)

---

## Descricao

Sistema de reservas de quadras com check-in multi-metodo, recorrencia e lista de espera.

## Funcionalidades

| Funcionalidade | Descricao |
|----------------|-----------|
| Reserva de Quadra | Selecao de data, horario, quadra e participantes |
| Check-in | QR Code, geolocalizacao ou manual |
| Lista de Espera | Fila automatica com notificacao |
| Recorrencia | Agendamentos semanais/mensais automaticos |
| Notificacoes | Confirmacao e lembrete via WhatsApp/Email |

## Tabelas Relacionadas

- `agendamentos` - Reservas de quadra
- `checkins` - Registros de check-in
- `lista_espera` - Fila de espera

## Fluxo de Agendamento (Cliente)

1. Login -> Dashboard do cliente
2. Selecionar data/hora -> Calendario disponivel
3. Escolher quadra -> Visualizar opcoes
4. Confirmar dados -> Revisar agendamento
5. Pagamento -> PIX/Cartao/Credito
6. Confirmacao -> WhatsApp + Email

## Fluxo de Check-in (Mobile)

1. Abrir app -> Lista de agendamentos
2. Selecionar agendamento -> Detalhes
3. Escolher metodo -> QR Code/GPS/Manual
4. Confirmar presenca -> Check-in realizado

## Status do Agendamento

| Status | Descricao |
|--------|-----------|
| `pendente` | Aguardando confirmacao/pagamento |
| `confirmado` | Confirmado e pago |
| `cancelado` | Cancelado pelo cliente ou admin |
| `realizado` | Check-in feito, aula/jogo concluido |
| `no_show` | Cliente nao compareceu |

## Permissoes

| Role | Acesso |
|------|--------|
| arena_admin | CRUD completo |
| funcionario | Criar, editar, cancelar |
| professor | Visualizar agenda propria |
| aluno | Criar reserva, visualizar proprias |

## Rota

```
app/(dashboard)/agendamentos/
```
