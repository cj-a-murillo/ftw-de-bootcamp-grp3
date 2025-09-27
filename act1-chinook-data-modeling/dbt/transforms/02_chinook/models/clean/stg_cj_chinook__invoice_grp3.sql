{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(invoice_id                       as Int64)        as invoice_id,
  cast(customer_id                      as Int64)        as customer_id,
  cast(invoice_date                     as DateTime)    as invoice_date,
  cast(COALESCE(billing_address,'')     as String) as billing_address,
  cast(COALESCE(billing_city,'')        as String) as billing_city,
  cast(COALESCE(billing_state, '')      as String) as billing_state,
  cast(COALESCE(billing_country,'')     as String) as billing_country,
  cast(COALESCE(billing_postal_code,'') as String) as billing_postal_code,
  cast(total                            as Numeric(10,2))     as invoice_total
from {{ source('raw', 'chinook_cj___invoices') }}