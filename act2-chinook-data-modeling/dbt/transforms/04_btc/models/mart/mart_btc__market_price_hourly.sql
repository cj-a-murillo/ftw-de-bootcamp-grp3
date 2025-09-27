{{ config(
    materialized = 'incremental',
    unique_key   = ['hour_local','coin_id'],
    incremental_strategy = 'delete+insert',
    schema       = 'mart',
    tags         = ['mart','btc'],
    order_by     = ['hour_local','coin_id'],
    partition_by = 'toYYYYMM(hour_local)'
) }}

with base as (
  select
    -- non-nullable for MergeTree keys
    toStartOfHour(toTimeZone(assumeNotNull(last_updated_utc), 'Asia/Manila')) as hour_local,
    assumeNotNull(coin_id)                                                    as coin_id,
    last_updated_utc,
    toFloat64(price_usd)                                                      as price_usd
  from {{ ref('stg_btc__market_price') }}
  where last_updated_utc is not null

  {% if is_incremental() %}
    -- Recompute only latest (and previous) Manila hours
    and toStartOfHour(toTimeZone(last_updated_utc,'Asia/Manila')) >= (
      select coalesce(max(hour_local), toStartOfHour(now('Asia/Manila')) - interval 1 hour)
      from {{ this }}
    ) - interval 1 hour
  {% endif %}
)
select
  hour_local,
  coin_id,
  min(price_usd)                      as low_usd,
  max(price_usd)                      as high_usd,
  argMin(price_usd, last_updated_utc) as open_usd,   -- first in hour
  argMax(price_usd, last_updated_utc) as close_usd   -- last in hour
from base
group by hour_local, coin_id
order by hour_local, coin_id
