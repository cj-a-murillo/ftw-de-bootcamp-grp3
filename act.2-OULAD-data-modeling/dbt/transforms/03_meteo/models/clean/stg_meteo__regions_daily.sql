-- models/clean/stg_meteo__regions_daily.sql
{{ config(materialized='view', schema='clean', tags=['staging','meteo']) }}

select
  cast(region_code as String)          as region_code,
  cast(region_name as String)          as region_name,
  toFloat64(latitude)                  as latitude,
  toFloat64(longitude)                 as longitude,
  toDate(date)                         as dte,
  toFloat64(temp_min)                  as temp_min_c,
  toFloat64(temp_max)                  as temp_max_c,
  toFloat64(precipitation)             as precip_mm,
  toInt32(weather_code)                as weather_code
from {{ source('raw','meteo___regions_daily') }}
