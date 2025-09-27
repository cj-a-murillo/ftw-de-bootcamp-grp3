{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(invoice_line_id  as Int64)    as invoice_line_id,
  cast(invoice_id       as Int64)    as invoice_id,
  cast(track_id         as Int64)    as track_id,
  cast(unit_price       as Numeric(10,2)) as unit_price,
  cast(quantity         as Int64)    as quantity
from {{ source('raw', 'chinook_cj___invoice_lines') }}