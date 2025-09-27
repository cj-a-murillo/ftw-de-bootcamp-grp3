{{ config(
    materialized = 'incremental',
    unique_key   = ['day_local','coin_id'],
    incremental_strategy = 'delete+insert',
    schema       = 'mart',
    tags         = ['mart','btc'],
    order_by     = ['day_local','coin_id'],
    partition_by = 'toYYYYMM(day_local)'
) }}

with base as (
  select
    assumeNotNull(toDate(toTimeZone(last_updated_utc,'Asia/Manila'))) as day_local,
    assumeNotNull(coin_id)                                            as coin_id,
    last_updated_utc,
    toFloat64(price_usd)                                              as price_usd
  from {{ ref('stg_btc__market_price') }}
  where last_updated_utc is not null

  {% if is_incremental() %}
    -- Recompute only latest (and previous) Manila days
    and toDate(toTimeZone(last_updated_utc,'Asia/Manila')) >= (
      select coalesce(max(day_local), toDate(now('Asia/Manila')) - 1)
      from {{ this }}
    ) - 1
  {% endif %}
)
select
  day_local,
  coin_id,
  min(price_usd)                      as low_usd,
  max(price_usd)                      as high_usd,
  argMin(price_usd, last_updated_utc) as open_usd,   -- first in day
  argMax(price_usd, last_updated_utc) as close_usd   -- last in day
from base
group by day_local, coin_id
order by day_local, coin_id
