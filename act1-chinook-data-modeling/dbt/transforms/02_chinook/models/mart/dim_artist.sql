{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

-- Simple conformed dimension for artists.
select
  artist_id,
  artist_name
from {{ ref('stg_chinook__artist') }}
