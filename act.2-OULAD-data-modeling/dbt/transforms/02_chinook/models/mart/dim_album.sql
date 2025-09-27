{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

-- Album dimension, denormalized with artist_name (common convenience).
with album as (
  select * from {{ ref('stg_chinook__album') }}
),
artist as (
  select * from {{ ref('stg_chinook__artist') }}
)
select
  a.album_id,
  a.album_title,
  a.artist_id,
  ar.artist_name
from album a
left join artist ar
  on ar.artist_id = a.artist_id
