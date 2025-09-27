{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

SELECT
	c.country as country,
	ROUND(avg(fi.unit_price),2) as avg_unit_price
FROM  {{ ref('fact_invoice_line_grp3') }} fi
JOIN {{ ref('dim_customer_grp3') }} c
	ON fi.customer_id= c.customer_id
GROUP BY country
ORDER BY avg_unit_price DESC

