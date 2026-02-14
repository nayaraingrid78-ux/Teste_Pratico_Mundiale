WITH approved_jul AS (
  SELECT 
    'key' AS approved_key,
    CAST(COUNT(id_sale) AS FLOAT) AS cont_approved_jul
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-07-01' AND '2023-07-31'
    AND id_operation = 1070
    AND status_venda = 'APROVADA'
),
sales_jul AS (
  SELECT
    'key' AS approved_key, 
    COUNT(id_sale) AS cont_sales_jul
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-07-01' AND '2023-07-31'
    AND id_operation = 1070
),

approved_ago AS (
  SELECT 
    'key' AS approved_key, 
    CAST(COUNT(id_sale) AS FLOAT) AS contap_ago
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-08-01' AND '2023-08-31' 
    AND id_operation = 1070 
    AND status_venda = 'APROVADA'
)
,
sales_ago AS (
  SELECT
    'key' AS approved_key, 
    COUNT(id_sale) AS cont_sales_ago
  FROM sales
  WHERE DATE(sale_created_at) BETWEEN '2023-08-01' AND '2023-08-31'
    AND id_operation = 1070
)

SELECT 
  apjul.cont_approved_jul, 
  sjul.cont_sales_jul, 
  apgo.contap_ago, 
  sago.cont_sales_ago,
  ROUND((cont_approved_jul / sjul.cont_sales_jul) * 100, 2) AS taxa_aprovado_sob_vendas_jul,
  ROUND((apgo.contap_ago / sago.cont_sales_ago) * 100, 2) AS taxa_aprovado_sob_vendas_ago
FROM approved_jul apjul
JOIN sales_jul sjul
  ON apjul.approved_key = sjul.approved_key
JOIN approved_ago apgo
  ON apjul.approved_key = apgo.approved_key
JOIN sales_ago sago
  ON apjul.approved_key = sago.approved_key;
