# Teste Pratico Mundiale
Este repositório contém a análise de performance da operação 1070, comparando os períodos de julho e agosto, com foco nos indicadores do funil de vendas, utilizando consultas SQL e análise interpretativa dos dados a partir da base de dados em SQLite.

## 📂 Estrutura do Repositório

```text
Teste_Pratico_Mundiale/
├── sql/
│   ├── funil_aprovadas.sql
│   ├── funil_engajados.sql
│   ├── funil_tickets.sql
│   └── funil_vendas.sql
│
├── perguntas_para_responder/
│   ├── pergunta_1.md
│   ├── pergunta_2.md
│   ├── pergunta_3.md
│   └── pergunta_4.md
````

## 📊 Pasta `sql/`

Nesta pasta estão as queries SQL utilizadas para construção dos dados do funil.

### Arquivos

* **funil_tickets:**
  Responsável por analisar o volume de tickets abertos, considerando toda interação com o BOT de vendas.

* **funil_engajados:**
  Analisa os clientes engajados no fluxo de vendas, ou seja, aqueles que interagiram efetivamente no funil.

* **funil_vendas:**
  Consolida os dados de vendas aprovadas, reprovadas e motivos de não conversão.

* **funil_aprovadas:**
  Analisa o status das vendaas aprovadas.

---

## 📝 Pasta `perguntas_para_responder/`

Contém a análise conceitual e interpretativa baseada nos dados extraídos via SQL.

### Perguntas respondidas

Com base nos dados do banco de dados, foi realizada a comparação da performance da operação 1070 nos períodos de **julho e agosto**, respondendo aos seguintes questionamentos:

* **(Pergunta 1)** Cite 3 motivos da queda de conversão entre os períodos.
* **(Pergunta 2)** Quais práticas de mercado poderiam ser implementadas para aumento de performance.
* **(Pergunta 3)** O que explica a diferença entre a performance do ATH e do BOT.
* **(Pergunta 4)** Apresente ações que poderiam ser realizadas nas etapas do funil para melhoria dos indicadores.

---

## 🔍 Conceitos do Funil

Os conceitos utilizados ao longo das análises seguem as definições abaixo:

* **Ticket:**
  Toda interação realizada com o BOT de vendas.

* **Engajados:**
  Cada cliente que interagiu no fluxo de venda.

* **Pedido:**
  Todo ticket cujo grupo é tabulado como venda.

* **Step:**
  Quebra dos casos de não venda, representando os pontos de abandono ou reprovação no funil.

* **Status venda:**
  Status das vendas realizadas pelo BOT.

* **Tag:**
  Quebra dos motivos de não aprovação das vendas.

---

## 🎯 Objetivo da Análise

* Avaliar a eficiência do funil de vendas automatizado.
* Identificar gargalos de conversão.
* Comparar a performance entre BOT e atendimento humano (ATH).
* Propor melhorias baseadas em dados para aumento de conversão e eficiência operacional.

---

## 🛠️ Tecnologias + Conhecimentos Utilizados

* SQL
* Análise de funil e métricas de conversão
* Interpretação orientada a negócio
