{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

WITH employee_quarter_sales AS (
    SELECT
        c.employee_id,
        d.year as year,
        d.quarter_name as quarter,
        SUM(f.line_amount) AS quarterly_sales
        FROM {{ ref('fact_invoice_line_grp3') }} f
    JOIN {{ ref('dim_customer_grp3') }} c
        ON f.customer_id = c.customer_id
    JOIN {{ ref('dim_date_grp3') }} d
        ON f.invoice_date = d.date
    GROUP BY c.support_rep_id, d.year, d.quarter
),
ranked AS (
    SELECT
        c.employee_id,
        d.year,
        d.quarter,
        quarterly_sales
        ROW_NUMBER() OVER (PARTITION BY (d.year, d.quarter) ORDER BY quarterly_sales DESC) AS rank
    FROM employee_quarter_sales
),
SELECT
    c.employee_id,
    year,
    quarter,
    quarterly_sales
FROM ranked
WHERE rank = 1
ORDER BY year, d.quarter
