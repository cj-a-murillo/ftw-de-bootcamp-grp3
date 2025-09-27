{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH track AS (
  SELECT * FROM {{ ref('stg_cj_chinook__track_cj') }}
)

SELECT
  track_id,
  track_name,
  album_id,
  genre_id,
  track_composer
FROM track
