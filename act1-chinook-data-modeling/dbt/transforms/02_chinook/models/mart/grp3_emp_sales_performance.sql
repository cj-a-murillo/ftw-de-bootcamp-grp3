{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

WITH employee_quarter_sales AS (
    SELECT
        c.support_rep_id AS employee_id,   -- use support_rep_id as employee
        d.year AS year,
        d.quarter_name AS quarter,
        SUM(f.line_amount) AS quarterly_sales
    FROM {{ ref('fact_invoice_line_grp3') }} f
    JOIN {{ ref('dim_customer_grp3') }} c
        ON f.customer_id = c.customer_id
    JOIN {{ ref('dim_date_grp3') }} d
        ON f.invoice_date = d.date
    GROUP BY c.support_rep_id, d.year, d.quarter_name
),
ranked AS (
    SELECT
        employee_id,
        year,
        quarter,
        quarterly_sales,
        ROW_NUMBER() OVER (
            PARTITION BY year, quarter
            ORDER BY quarterly_sales DESC
        ) AS rank
    FROM employee_quarter_sales
)
SELECT
    employee_id,
    year,
    quarter,
    quarterly_sales
FROM ranked
WHERE rank = 1
ORDER BY year, quarter