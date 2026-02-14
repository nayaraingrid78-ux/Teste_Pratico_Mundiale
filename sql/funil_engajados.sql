with 
  
engaged_jul as (
  select 
    'chave' corigin,
    count(distinct contact_origin) as econtact_jul
  from engaged_tickets
  where date(dt_criacao) BETWEEN '2023-07-01' AND '2023-07-31' 
    AND id_operation = 1070    
)
, engaged_ago as (
  select 
    'chave' corigin, 
    CAST (count(distinct contact_origin) AS Float) as econtact_ago
  from engaged_tickets
  where date(dt_criacao) BETWEEN '2023-08-01' AND '2023-08-31' 
    AND id_operation = 1070
)
        
select 
  *, 
  ROUND (((a.econtact_ago/ j.econtact_jul)-1) *100, 2)
from engaged_jul j
JOIN engaged_ago a
ON a.corigin = j.corigin
