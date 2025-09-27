{{ config(
    materialized = 'table',
    schema       = 'mart',
    tags         = ['mart','meteo'],
    order_by     = ['dte'],
    partition_by = 'toYYYYMM(dte)'
) }}

-- Force non-nullable key for MergeTree
select
  assumeNotNull(dte)                         as dte,          -- 👈 non-nullable
  temp_min_c,
  temp_max_c,
  (temp_min_c + temp_max_c)/2.0              as temp_avg_c,
  precip_mm,
  weather_code
from {{ ref('stg_meteo__manila') }}
