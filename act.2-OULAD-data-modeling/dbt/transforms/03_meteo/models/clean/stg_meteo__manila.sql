{{ config(materialized="view", schema="clean", tags=["staging","meteo"]) }}

-- Normalize types & naming; no business logic here.
select
  toDate(date)                         as dte,
  toFloat64(temp_min)                  as temp_min_c,
  toFloat64(temp_max)                  as temp_max_c,
  toFloat64(precipitation)             as precip_mm,
  toInt32(weather_code)                as weather_code
from {{ source('raw', 'meteo___manila') }}
