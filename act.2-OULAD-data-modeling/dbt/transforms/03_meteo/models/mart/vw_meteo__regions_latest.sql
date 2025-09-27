-- models/mart/vw_meteo__regions_latest.sql
{{ config(materialized='view', schema='mart', alias='vw_meteo__regions_latest', tags=['mart','meteo','viz']) }}

with last_dates as (
  select region_code, max(dte) as dte_max
  from {{ ref('stg_meteo__regions_daily') }}
  group by region_code
)
select
  s.region_code,
  s.region_name,
  s.latitude,
  s.longitude,
  s.dte,
  s.temp_min_c,
  s.temp_max_c,
  (s.temp_min_c + s.temp_max_c)/2.0 as temp_avg_c,
  s.precip_mm,
  s.weather_code
from {{ ref('stg_meteo__regions_daily') }} s
join last_dates ld
  on s.region_code = ld.region_code and s.dte = ld.dte_max
order by s.region_code
