{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

WITH genre_revenue AS (
    SELECT
        c.country AS country,
        g.genre_name AS genre_name,
        SUM(fi.line_amount) AS total_revenue,
        RANK() OVER (
            PARTITION BY c.country 
            ORDER BY SUM(fi.line_amount) DESC
        ) AS genre_rank
    FROM {{ ref('fact_invoice_line_grp3') }} fi
    JOIN {{ ref('dim_customer_grp3') }} c 
        ON fi.customer_id = c.customer_id
    JOIN {{ ref('dim_track_grp3') }} t 
        ON fi.track_id = t.track_id
    JOIN {{ ref('dim_genre_grp3') }} g 
        ON fi.genre_id = g.genre_id
    GROUP BY c.country, g.genre_name
)

SELECT
    genre_name,
    country,
    total_revenue
FROM genre_revenue
WHERE genre_rank = 1
ORDER BY country, total_revenue DESC
