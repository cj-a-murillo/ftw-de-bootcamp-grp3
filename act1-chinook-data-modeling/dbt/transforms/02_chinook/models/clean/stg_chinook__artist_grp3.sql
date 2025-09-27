{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(artist_id as Int64)      as artist_id,
  cast(name      as String)     as artist_name
from {{ source('raw', 'chinook_grp3___artists') }}
