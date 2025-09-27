{{config(materialized = "view", schema="mart", tags = ["mart", "chinook"])}}

select
    d.year as year,
    d.month as month,
    sum(f.line_amount) as total_revenue
    from {{ ref('fact_invoice_line_grp3') }} f
    join {{ ref('dim_date_grp3') }} d
        on f.invoice_date = d.date
    where d.date >= addYears(today(), -2)
    group by (year, month)
    order by year, month