{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

select
  genre_id,
  genre_name
from {{ ref('stg_chinook__genre_grp3') }}
