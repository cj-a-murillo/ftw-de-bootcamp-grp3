{{ config(materialized="view", schema="mart", tags=["mart", "chinook"]) }}

WITH employee_monthly_sales AS (
    SELECT
        c.support_rep_id AS emp_id,
        d.year AS year,
        d.month AS month,
        CASE d.month
            WHEN 1 THEN 'January'
            WHEN 2 THEN 'February'
            WHEN 3 THEN 'March'
            WHEN 4 THEN 'April'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'June'
            WHEN 7 THEN 'July'
            WHEN 8 THEN 'August'
            WHEN 9 THEN 'September'
            WHEN 10 THEN 'October'
            WHEN 11 THEN 'November'
            WHEN 12 THEN 'December'
        END AS month_name,
        SUM(f.line_amount) AS amount_per_month
    FROM {{ ref('fact_cj_invoice_line') }} f
    JOIN {{ ref('dim_cj_customer') }} c
        ON f.customer_id = c.customer_id
    JOIN {{ ref('dim_cj_date') }} d
        ON f.invoice_date = d.date
    GROUP BY c.support_rep_id, d.year, d.month
),
employee_quarter_sales AS (
    SELECT
        m.emp_id,
        concat('Q', toString(d.quarter), '-', toString(d.year)) AS quarter,
        SUM(m.amount_per_month) AS amount_per_qtr
    FROM employee_monthly_sales m
    JOIN {{ ref('dim_cj_date') }} d
        ON m.year = d.year
       AND m.month = d.month
    GROUP BY m.emp_id, d.year, d.quarter
),
ranked AS (
    SELECT
        emp_id,
        quarter,
        amount_per_qtr,
        ROW_NUMBER() OVER (PARTITION BY quarter ORDER BY amount_per_qtr DESC) AS rank
    FROM employee_quarter_sales
)
SELECT
    emp_id,
    quarter,
    amount_per_qtr
FROM ranked
WHERE rank = 1
ORDER BY quarter

