{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH customer AS (
  SELECT * FROM {{ ref('stg_chinook___customer_grp3') }}
)

SELECT
  customer_id,
  country AS country,
  support_rep_id
FROM customer
