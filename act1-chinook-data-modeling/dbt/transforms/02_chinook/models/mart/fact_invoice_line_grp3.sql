{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH invoice_line AS (
  SELECT * FROM {{ ref('stg_cj_chinook__invoiceLine_cj') }}
),
invoice AS (
  SELECT * FROM {{ ref('stg_cj_chinook__invoice_cj') }}
),
customer AS (
  SELECT * FROM {{ ref('stg_cj_chinook___customer_cj') }}
),
track AS (
  SELECT * FROM {{ ref('stg_cj_chinook__track_cj') }}
),
dim_date AS (
  SELECT * FROM {{ ref('dim_cj_date') }}
)

SELECT
  il.invoice_line_id AS invoice_line_id,
  il.invoice_id AS invoice_id,
  c.customer_id AS customer_id,
  t.track_id AS track_id,
  i.invoice_date AS invoice_date,                     
  il.track_qty_purchased AS quantity,
  il.track_unit_price AS unit_price,
  cast((il.track_qty_purchased * il.track_unit_price) as numeric(10,2)) AS line_amount
FROM invoice_line il
LEFT JOIN invoice i
  ON il.invoice_id = i.invoice_id
LEFT JOIN dim_date d
  ON i.invoice_date = d.date         
LEFT JOIN customer c 
  ON i.customer_id = c.customer_id
LEFT JOIN track t
  ON il.track_id = t.track_id
