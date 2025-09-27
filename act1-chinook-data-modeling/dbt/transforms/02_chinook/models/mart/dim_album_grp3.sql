{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

-- Album dimension, denormalized with artist_name (common convenience).
select
  album_id,
  album_title
from {{ ref('stg_chinook__album_grp3') }}


