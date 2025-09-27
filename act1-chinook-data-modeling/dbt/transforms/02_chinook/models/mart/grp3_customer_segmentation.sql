{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

WITH customer_spend AS (
    SELECT
        fi.customer_id,
        SUM(fi.line_amount) AS total_spend
    FROM {{ ref('fact_invoice_line_grp3') }} fi
    GROUP BY fi.customer_id
),
bounds AS (
    SELECT
        min(total_spend) AS min_spend,
        max(total_spend) AS max_spend,
        (max(total_spend) - min(total_spend)) / 3.0 AS interval_size
    FROM customer_spend
)
SELECT
    CASE
        WHEN cs.total_spend <= b.min_spend + b.interval_size THEN 'Low'
        WHEN cs.total_spend <= b.min_spend + 2 * b.interval_size THEN 'Medium'
        ELSE 'High'
    END AS spend_tier,
    COUNT(DISTINCT cs.customer_id) AS customer_count
FROM customer_spend cs
CROSS JOIN bounds b
GROUP BY spend_tier, b.min_spend, b.interval_size
ORDER BY spend_tier
