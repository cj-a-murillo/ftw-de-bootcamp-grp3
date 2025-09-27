{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(invoice_id                       as Nullable(Int64))           as invoice_id,
  cast(customer_id                      as Nullable(Int64))           as customer_id,
  cast(invoice_date                     as Nullable(Date))            as invoice_date,
  cast(billing_address                  as Nullable(String))          as billing_address,
  cast(billing_city                     as Nullable(String))          as billing_city,
  cast(billing_state                    as Nullable(String))          as billing_state,
  cast(billing_country                  as Nullable(String))          as billing_country,
  cast(billing_postal_code              as Nullable(String))          as billing_postal_code,
  cast(total                            as Nullable(Numeric(10,2)))   as invoice_total
from {{ source('raw', 'chinook_grp3___invoices') }}