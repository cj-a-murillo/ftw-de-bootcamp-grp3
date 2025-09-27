{{ config(materialized="view", schema="mart") }}

select
  origin,
  avg(cylinders) as avg_cylinders,
  count()        as n
from {{ ref('mpg_standardized') }}
group by origin
