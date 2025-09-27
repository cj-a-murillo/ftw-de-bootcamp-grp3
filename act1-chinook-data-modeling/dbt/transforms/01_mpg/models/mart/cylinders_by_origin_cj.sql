{{ config(materialized="view", schema="mart") }}
#materialized as view to allow for quick iteration during development
#schema is "mart" to separate from raw and clean layers

select
  origin,
  avg(cylinders) as avg_cylinders,
  count()        as n
from {{ ref('mpg_standardized_cj') }}
group by origin
