{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(genre_id           as Int64)          as genre_id,
  cast(name  as String)   as genre_name
from {{ source('raw', 'chinook_cj___genres') }}