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
albums as (
  select * from {{ ref('stg_chinook__album_grp3') }}
),
artists as (
  select * from {{ ref('stg_chinook__artist_grp3') }}
),
genres as (
  select * from {{ ref('stg_chinook__genre_grp3') }}
)

select
    il.invoice_line_id  AS invoice_line_key,
    c.customer_id       AS customer_key,
    t.track_id          AS track_key,
    al.album_id         AS album_key,
    ar.artist_id        AS artist_key
    g.genre_id          AS genre_key,
    i.invoice_date      AS invoice_date,
    il.unit_price       AS unit_price,
    il.quantity         AS quantity,
    (il.unit_price * il.quantity) AS line_amount
from invoice_lines il
left join invoices i
  on il.invoice_id = i.invoice_id
join customers c
  on i.customer_id = c.customer_id
join tracks t
  on il.track_id = t.track_id
join albums al
  on t.album_id = al.album_id
join artists ar
  on al.artist_id = ar.artist_id
join genres g
  on t.genre_id = g.genre_id
