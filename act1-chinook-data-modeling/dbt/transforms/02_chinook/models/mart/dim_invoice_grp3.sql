{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

select
    invoice_id,
    invoice_date,
    customer_id
from {{ ref('stg_cj_chinook__invoice_cj') }}
