{{config(materialized = "view", schema="mart", tags = ["mart", "chinook"])}}

with monthly_sales_trend as (
    select
        d.year,
        d.month,
        sum(f.line_amount) as total_revenue
    from {{ ref('fact_cj_invoice_line') }} f
    join {{ ref('dim_cj_date') }} d
        on f.invoice_date = d.date
    where d.date >= addYears(today(), -2)
    group by d.year, d.month
)

select
    year,
    month,
    total_revenue
from monthly_sales_trend
order by year, month