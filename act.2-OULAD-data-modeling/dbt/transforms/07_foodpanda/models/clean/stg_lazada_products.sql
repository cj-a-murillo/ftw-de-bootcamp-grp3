

-- models/clean/stg_lazada_products.sql
{{ config(materialized="view") }}

with base as (
  select
    -- keep page numeric; remove OrZero (that's for String inputs)
    toInt32(page)                      as page,
    name,
    ifNull(price, '')                  as price_str,      -- ensure NON-NULL String
    url
  from {{ source('raw', 'lazada_products_20250827063214___lazada_products') }}
  where url is not null
),

-- Pull out every number-like token (supports: 2,609 • 2,124.24 • 145.5 • 12,136.01)
tokens as (
  select
    *,
    extractAll(price_str, '(\\d[\\d,\\.]*)') as num_strs
  from base
),

-- Normalize: remove thousands separators, cast to floats
norm as (
  select
    page,
    name,
    price_str,
    url,
    arrayMap(x -> toFloat64OrZero(replaceAll(x, ',', '')), num_strs) as num_vals
  from tokens
)

select
  page,
  name,
  price_str                              as price_raw,
  url,

  -- if single value -> min=max=avg; if a range -> min/max distinct
  if(empty(num_vals), NULL, arrayMin(num_vals))                               as min_price,
  if(empty(num_vals), NULL, arrayMax(num_vals))                               as max_price,
  if(empty(num_vals), NULL, round( (arrayMin(num_vals) + arrayMax(num_vals)) / 2, 2)) as price_avg,
  length(num_vals) > 1                                                        as is_price_range
from norm
