{{ config(materialized="view", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(artist_id as Nullable(Int64))      as artist_id,
  cast(name      as Nullable(String))     as artist_name
from {{ source('raw', 'chinook___artists') }}
