{{ config(materialized="view") }}

select
  avg(hp)               as avg_hp,
  avg(attack)           as avg_attack,
  avg(defense)          as avg_defense,
  avg(special_attack)   as avg_special_attack,
  avg(special_defense)  as avg_special_defense,
  avg(speed)            as avg_speed,
  avg(height_m)         as avg_height_m,
  avg(weight_kg)        as avg_weight_kg,
  countDistinct(pokemon_id) as n_pokemon
from {{ ref('stg_pokemon') }}
