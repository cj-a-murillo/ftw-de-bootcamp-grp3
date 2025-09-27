{{ config(materialized="view") }}

with base as (
  select
    toInt32(id)     as pokemon_id,
    lowerUTF8(name) as pokemon_name,
    toInt32(height) as height_dm,
    toInt32(weight) as weight_hg,
    base_stats_json,
    sprite_url
  from {{ source('raw', 'pokemon___gen1') }}
)
select
  pokemon_id,
  pokemon_name,
  (height_dm * 0.1) as height_m,
  (weight_hg * 0.1) as weight_kg,

  JSONExtractInt(base_stats_json, 'hp')               as hp,
  JSONExtractInt(base_stats_json, 'attack')           as attack,
  JSONExtractInt(base_stats_json, 'defense')          as defense,
  JSONExtractInt(base_stats_json, 'special-attack')   as special_attack,
  JSONExtractInt(base_stats_json, 'special-defense')  as special_defense,
  JSONExtractInt(base_stats_json, 'speed')            as speed,

  sprite_url
from base
