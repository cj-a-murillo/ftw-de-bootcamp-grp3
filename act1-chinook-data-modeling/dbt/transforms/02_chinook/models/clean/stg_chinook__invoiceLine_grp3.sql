{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(invoice_line_id  as Nullable(Int64))         as invoice_line_id,
  cast(invoice_id       as Nullable(Int64))         as invoice_id,
  cast(track_id         as Nullable(Int64))         as track_id,
  cast(unit_price       as Nullable(Numeric(10,2))) as track_unit_price,
  cast(quantity         as Nullable(Int64))         as track_qty_purchased
from {{ source('raw', 'chinook_grp3___invoice_lines') }}