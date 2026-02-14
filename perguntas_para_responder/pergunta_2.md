
Essa query teve como objetivo analisar a taxa de conversão dos clientes engajados em vendas nos meses de julho e agosto. Inicialmente, foram extraídos os valores totais de vendas e o número de clientes engajados em cada período, com o intuito de avaliar se o volume de engajamento estava se convertendo de forma eficiente em vendas.

Para organizar a análise e consolidar os indicadores em uma única consulta, foram criadas quatro CTEs, responsáveis por resumir separadamente os dados de engajamento e vendas de julho e de agosto. A lógica aplicada foi a mesma para ambos os períodos, utilizando tabelas temporárias para organizar a query e permitir o cálculo das taxas dentro de uma única consulta, centralizando a análise e deixando o código mais claro, sem a necessidade de múltiplas querys. Além disso, foi criada uma chave artificial para possibilitar a consolidação dos indicadores em uma única linha, e utilizada a função `DATE` para garantir que todos os dados do período fossem extraídos corretamente.

Com os valores consolidados, foi realizado o cálculo da taxa de conversão, definida como a razão entre o total de vendas e o total de clientes engajados em cada mês, expressa em percentual. O resultado indicou que, no mês de julho, a taxa de conversão dos leads engajados foi de **26,32%**, evidenciando que apenas uma parcela reduzida dos clientes que entraram no funil efetivamente se converteu em venda, ficando abaixo do esperado para o período. A mesma métrica aplicada ao mês de agosto também apresentou um desempenho inferior ao esperado, com uma taxa de conversão de **24,84%**. Comparando os dois meses, foi possível identificar uma **queda de 1,48 ponto percentual** na taxa de conversão de julho para agosto.

---

```sql
select
    CASE
        WHEN motivo_reprovacao LIKE '%VIABILIDADE%' OR motivo_reprovacao like '%DISPONIBILIDADE%' THEN 'PROBLEMA COM VIABILIDADE'
        when motivo_reprovacao LIKE '%PENDENCIA%' OR motivo_reprovacao like '%PENDÊNCIA%'  THEN 'PROBLEMA COM PENDENCIA'
        ELSE motivo_reprovacao
    END motivo_reprovacao_normalizado, 
    count(*)
from sales
where motivo_reprovacao  NOT LIKE '%TESTE%' AND motivo_reprovacao not like '%APROVADA%'
GROUP BY motivo_reprovacao_normalizado
Order by 2 desc
```

Nessa query, o objetivo foi analisar e consolidar os motivos de reprovação das vendas, agrupando variações de texto semelhantes em categorias padronizadas para facilitar a leitura e a análise dos dados.

Para isso, foi utilizado um CASE WHEN para normalizar o campo motivo_reprovacao, agrupando diferentes descrições que representam o mesmo problema de negócio. Motivos que continham os termos “VIABILIDADE” ou “DISPONIBILIDADE” foram classificados como “PROBLEMA COM VIABILIDADE”, enquanto aqueles que continham “PENDENCIA” ou “PENDÊNCIA” foram agrupados como “PROBLEMA COM PENDENCIA”. Os demais motivos foram mantidos com a descrição original.

No filtro WHERE, foram excluídos registros relacionados a testes e vendas aprovadas, garantindo que a análise considerasse apenas casos reais de reprovação. Em seguida, os dados foram agrupados pelo motivo de reprovação normalizado e contabilizados, permitindo identificar quais categorias concentraram o maior volume de reprovações.

Por fim, o resultado foi ordenado pela quantidade de ocorrências em ordem decrescente, destacando os principais motivos de reprovação e fornecendo uma visão clara dos gargalos que impactam diretamente a conversão de vendas.

---

Identifiquei que %

### **Pendências de pagamento concentradas na etapa final do funil**

Apesar do aumento no volume de clientes engajados, houve um crescimento proporcionalmente maior de casos em que a compra não foi concluída por pendência de pagamento. Isso indica que o chatbot consegue conduzir bem o usuário até etapas avançadas, mas enfrenta fricção no momento de fechamento, seja por limitações nos meios de pagamento, falta de clareza nas instruções ou abandono no momento da confirmação.

As principais hipoteses levantadas foram falta de qualificacao do lead nas etapas iniciais do chatbot o qual os leads nao qualificados que nao correspondiam o ICP da empresa acabaram passando e identificaram restricoes e acabaram abandonando a compra e nao aprovando.

### **Identificação tardia de problemas de viabilidade**

Parte relevante dos clientes avançou no funil sem atender aos critérios de viabilidade do serviço, como restrições técnicas, regionais ou de elegibilidade. Esses critérios só foram identificados após o engajamento inicial, o que inflou o volume de leads engajados, mas reduziu a conversão efetiva em vendas.

Outro fator que pode ter contribuído para a queda de conversão é a **complexidade do formulário enviado por e-mail marketing**. Um formulário extenso ou pouco intuitivo tende a gerar abandono durante o preenchimento ou envio incompleto das informações, o que resulta em **pendência de documentos** e, consequentemente, na não conclusão da compra.

Esse tipo de fricção é especialmente crítico em fluxos automatizados, pois o cliente não conta com suporte imediato para esclarecer dúvidas ou corrigir erros. Dessa forma, mesmo clientes com intenção de compra acabam não avançando no funil devido à dificuldade operacional, o que ajuda a explicar o aumento de reprovações por pendência, apesar do bom nível de engajamento nos meses de agosto e julho.

A diferença entre o número de pedidos concluídos pelo chatbot (418) e pelo atendimento humano (27) está relacionada ao papel de cada canal no funil. O chatbot concentra o atendimento em larga escala, atuando principalmente no topo e meio da jornada, onde finaliza fluxos operacionais e registra pedidos, o que naturalmente gera um volume maior de conclusões.

Já o atendimento humano atua de forma mais seletiva, geralmente em casos mais complexos ou próximos do fechamento, o que reduz o volume, mas aumenta a qualidade dos atendimentos. Além disso, o status “pedido concluído” no fluxo do chatbot não necessariamente representa uma venda efetivada, enquanto no atendimento humano tende a estar mais associado à conclusão real da compra.

Esse cenário indica que o alto volume de pedidos concluidos pelo BOT reflete a estratégia de escala do canal, enquanto o baixo número no atendimento humano aponta para uma atuação focada em casos específicos, além de possíveis gargalos pós-bot, como pendências de pagamento e problemas de viabilidade, que impactam a conversão final. Talvez a segmentacao do bot nao esteja correta, ou seja misturando casos de suporte tecnico com inrteressados em vendas indicando um possivel problema de automacao dentro bot, em que os atendimentos se misturam.

---

```sql
SELECT
    finalizado_por,
    step,
    COUNT(*) AS total
FROM engaged_tickets
WHERE 
    step = 'PEDIDO CONCLUÍDO'
    OR step LIKE '%CONCLUÍDO%'
GROUP BY
finalizado_por,
step;
```

```sql
with engage_sales as
(
    SELECT 
        et.finalizado_por, 
        et.step, 
        s.status_venda
    from engaged_tickets et
    JOIN sales s
        on et.id_ticket = s.id_ticket
)
```

Nessa query, foi utilizado o princípio de CTEs para **comparar os dois cenários de atendimento, humano e chatbot**, com o objetivo de identificar qual canal apresentou **maior volume de abandonos** no período analisado, considerando a operação 1070 entre os meses de julho e agosto.

Para isso, foram criadas duas CTEs. A primeira consolida o total de abandonos ocorridos em atendimentos finalizados pelo chatbot, enquanto a segunda consolida os abandonos nos atendimentos finalizados por agentes humanos (ATH). Em ambos os casos, os dados foram agregados em nível de resumo, retornando uma única linha por canal, o que permitiu a comparação direta dos indicadores em uma única consulta.

A análise dos resultados indicou que o **atendimento humano apresentou um número maior de abandonos** em relação ao chatbot. Esse comportamento pode estar relacionado a fatores operacionais, como maior tempo de resposta, dependência de etapas adicionais após o repasse do atendimento do BOT para o humano e aumento da fricção ao longo da jornada. Além disso, fluxos extensos ou pouco claros, excesso de etapas automatizadas antes do contato humano, mensagens pouco objetivas e a mistura de diferentes assuntos dentro do mesmo fluxo podem contribuir para a perda de interesse do cliente durante o atendimento humano.

Como oportunidade de melhoria, destaca-se a importância de **segmentar melhor os fluxos de atendimento**, criando caminhos distintos conforme a intenção do cliente identificada nas mensagens iniciais. Por exemplo, ao identificar palavras-chave como “suporte”, o cliente poderia ser direcionado automaticamente para a equipe responsável por essa tratativa. Adicionalmente, a construção de um **mapa da jornada do cliente**, detalhando todas as etapas até a compra, pode ajudar a identificar pontos de fricção e oportunidades de otimização do fluxo em cada interação.
