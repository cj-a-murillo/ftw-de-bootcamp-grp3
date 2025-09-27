{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

-- models/mart/grp3_top_tracks.sql

SELECT 
    t.track_name AS track_name,
    al.album_title AS album_title,
    ar.artist_name AS artist_name,
    any(il.unit_price) AS unit_price,  
    SUM(il.quantity) AS total_quantity,
    SUM(il.line_amount) AS total_amount
FROM {{ ref('fact_invoice_line_grp3') }} il
JOIN {{ ref('dim_track_grp3') }} t 
    ON il.track_id = t.track_id
JOIN {{ ref('dim_album_grp3') }} al
    ON il.album_id = al.album_id
JOIN {{ ref('dim_artist_grp3') }} ar
    ON il.artist_id = ar.artist_id
GROUP BY 
    t.track_name,
    al.album_title,
    ar.artist_name
ORDER BY total_quantity DESC
LIMIT 20

