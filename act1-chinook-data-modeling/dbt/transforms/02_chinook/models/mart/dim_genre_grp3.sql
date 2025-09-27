{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

select
  genre_id,
  genre_name
from {{ ref('stg_cj_chinook__genre_cj') }}
