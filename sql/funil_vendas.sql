WITH engaged_jul AS (
  SELECT 
    'key' AS engaged_key, 
    CAST(COUNT(DISTINCT contact_origin) AS FLOAT) AS cont_engaged_jul
  FROM engaged_tickets
  WHERE DATE(dt_criacao) BETWEEN '2023-07-01' AND '2023-07-31'
    AND id_operation = 1070
),
sales_jul AS (
  SELECT
    'key' AS engaged_key, 
    COUNT(id_sale) AS cont_sales_jul
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-07-01' AND '2023-07-31'
    AND id_operation = 1070
),
engaged_ago AS (
  SELECT 
    'key' AS engaged_key, 
    CAST(COUNT(DISTINCT contact_origin) AS FLOAT) AS cont_engaged_ago
  FROM engaged_tickets
  WHERE DATE(dt_criacao) BETWEEN '2023-08-01' AND '2023-08-31'
    AND id_operation = 1070
),
sales_ago AS (
  SELECT
    'key' AS engaged_key, 
    COUNT(id_sale) AS cont_sales_ago
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-08-01' AND '2023-08-31'
    AND id_operation = 1070
)

SELECT 
  e.cont_engaged_jul,
  s.cont_sales_jul,
  ea.cont_engaged_ago,
  sa.cont_sales_ago,
  ROUND((s.cont_sales_jul / e.cont_engaged_jul) * 100, 2) AS taxa_engajamento_sobre_vendas_jul,
  ROUND((sa.cont_sales_ago / ea.cont_engaged_ago) * 100, 2) AS taxa_engajamento_sobre_vendas_ago
FROM engaged_jul e
JOIN sales_jul s
  ON e.engaged_key = s.engaged_key
JOIN engaged_ago ea
  ON e.engaged_key = ea.engaged_key
JOIN sales_ago sa
  ON ea.engaged_key = sa.engaged_key;
