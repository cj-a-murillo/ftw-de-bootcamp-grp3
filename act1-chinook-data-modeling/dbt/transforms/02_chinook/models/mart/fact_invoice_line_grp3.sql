{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH invoice_line AS (
  SELECT * FROM {{ ref('stg_chinook__invoiceLine_grp3') }}
),
invoice AS (
  SELECT * FROM {{ ref('stg_chinook__invoice_grp3') }}
),
customer AS (
  SELECT * FROM {{ ref('stg_chinook___customer_grp3') }}
),
track AS (
  SELECT * FROM {{ ref('stg_chinook__track_grp3') }}
),
album AS (
  SELECT * FROM {{ ref('stg_chinook__album_grp3') }}
),
artist AS (
  SELECT * FROM {{ ref('stg_chinook__artist_grp3') }}
),
dim_date AS (
  SELECT * FROM {{ ref('dim_date_grp3') }}
)

SELECT
  il.invoice_line_id AS invoice_line_id,
  il.invoice_id AS invoice_id,
  c.customer_id AS customer_id,
  t.track_id AS track_id,
  t.genre_id AS genre_id,              
  al.album_id AS album_id,              
  ar.artist_id AS artist_id,            
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
LEFT JOIN album al
  ON t.album_id = al.album_id
LEFT JOIN artist ar
  ON al.artist_id = ar.artist_id
