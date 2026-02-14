with 

tickets_julho AS (
    select 
        'tickets' tickets_key,
        CAST(count(id_ticket) AS FLOAT) AS value
    from engaged_tickets
    where 
        DATE(dt_criacao) BETWEEN '2023-07-01' AND '2023-07-31' 
        AND id_operation = 1070
)

, tickets_agosto AS (
    select 
        'tickets' tickets_key,
        COUNT(id_ticket) AS value
    from engaged_tickets
    where 
        DATE(dt_criacao) BETWEEN '2023-08-01' AND '2023-08-31' 
        AND id_operation = 1070
)

SELECT
    tickets_julho.value AS ticket_julho_total,
    tickets_agosto.value AS ticket_agosto_total,
    ROUND(((tickets_agosto.value / tickets_julho.value) - 1) * 100, 2) AS ticket_percent
FROM tickets_julho
JOIN tickets_agosto
    ON tickets_julho.tickets_key = tickets_agosto.tickets_key;
    
