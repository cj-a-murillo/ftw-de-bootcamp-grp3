{{ config(materialized="view") }}

-- Bucket prices by ₱500 for a quick histogram
select
  intDiv(toInt64(price_avg), 500) * 500  as price_bin_php,
  count()                                as n_products
from {{ ref('stg_lazada_products') }}
where price_avg is not null
group by price_bin_php
order by price_bin_php
