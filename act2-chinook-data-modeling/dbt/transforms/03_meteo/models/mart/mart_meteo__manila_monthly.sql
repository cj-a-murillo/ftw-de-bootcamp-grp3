{{ config(
    materialized = 'table',
    schema       = 'mart',
    tags         = ['mart','meteo'],
    order_by     = ['month'],
    partition_by = 'toYYYYMM(month)'
) }}

with base as (
  select
    assumeNotNull(dte)                            as dte_nn,   -- 👈 non-nullable
    toFloat64(temp_min_c)                         as temp_min_c,
    toFloat64(temp_max_c)                         as temp_max_c,
    (toFloat64(temp_min_c) + toFloat64(temp_max_c))/2.0 as temp_avg_c,
    toFloat64(precip_mm)                          as precip_mm
  from {{ ref('stg_meteo__manila') }}
)
select
  toStartOfMonth(dte_nn)                as month,             -- 👈 computed from non-null date
  avg(temp_min_c)                       as avg_min_c,
  avg(temp_max_c)                       as avg_max_c,
  avg(temp_avg_c)                       as avg_temp_c,
  sum(precip_mm)                        as total_precip_mm,
  countIf(precip_mm > 0)                as rainy_days
from base
group by month
order by month
