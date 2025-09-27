{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH customer AS (
  SELECT * FROM {{ ref('stg_cj_chinook___customer_cj') }}
)

SELECT
  customer_id,
  country AS country,
  support_rep_id
FROM customer
