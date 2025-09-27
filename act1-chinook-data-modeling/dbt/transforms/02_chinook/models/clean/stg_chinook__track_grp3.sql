{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(track_id               as Nullable(Int64))          as track_id,
  cast(name                   as Nullable(String))         as track_name,
  cast(album_id               as Nullable(Int64))          as album_id,
  cast(media_type_id          as Nullable(Int64))          as media_type_id,
  cast(genre_id               as Nullable(Int64))          as genre_id,
  cast(composer               as Nullable(String))         as track_composer,
  cast(milliseconds           as Nullable(Int64))          as track_milliseconds,
  cast(bytes                  as Nullable(Int64))          as track_bytes,
  cast(unit_price             as Numeric(10,2))            as track_unit_price
from {{ source('raw', 'chinook_grp3___tracks') }}
