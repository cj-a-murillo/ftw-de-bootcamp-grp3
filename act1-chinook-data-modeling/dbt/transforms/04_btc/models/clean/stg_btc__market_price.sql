-- models/clean/stg_btc__market_price.sql
{{ config(materialized='view', schema='clean', tags=['staging','btc']) }}

select
  cast(id as String)                       as coin_id,
  cast(symbol as String)                   as symbol,
  cast(name as String)                     as name,
  cast(image as String)                    as image_url,
  toFloat64(current_price)                 as price_usd,
  toFloat64(market_cap)                    as market_cap_usd,
  toInt32(market_cap_rank)                 as market_cap_rank,
  toFloat64(total_volume)                  as total_volume_usd,
  toFloat64(high_24h)                      as high_24h_usd,
  toFloat64(low_24h)                       as low_24h_usd,
  toFloat64(price_change_24h)              as price_change_24h_usd,
  toFloat64(price_change_percentage_24h)   as price_change_pct_24h,

  -- Normalize last_updated to DateTime64(6,'UTC') whether it's already DT or a String
  ifNull(
    parseDateTime64BestEffortOrNull(toString(last_updated), 6, 'UTC'),
    toDateTime64(last_updated, 6, 'UTC')
  )                                        as last_updated_utc,

  toTimeZone(
    ifNull(
      parseDateTime64BestEffortOrNull(toString(last_updated), 6, 'UTC'),
      toDateTime64(last_updated, 6, 'UTC')
    ),
    'Asia/Manila'
  )                                        as last_updated_manila

from {{ source('raw','btc___market_price') }}
