{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

SELECT
  customer_id,
  country AS country,
  support_rep_id as employee_id
FROM customer {{ ref('stg_chinook___customer_grp3') }}
