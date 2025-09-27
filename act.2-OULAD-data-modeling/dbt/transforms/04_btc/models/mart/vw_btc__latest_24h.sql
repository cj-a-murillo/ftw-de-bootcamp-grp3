{{ config(
    materialized = 'view',
    schema       = 'mart',
    alias        = 'vw_btc__latest_24h',
    tags         = ['mart','btc','viz']
) }}

WITH (SELECT max(last_updated_utc) FROM {{ ref('stg_btc__market_price') }}) AS ts_max
SELECT
  *
FROM {{ ref('stg_btc__market_price') }}
WHERE last_updated_utc >= ts_max - INTERVAL 24 HOUR
ORDER BY last_updated_utc
