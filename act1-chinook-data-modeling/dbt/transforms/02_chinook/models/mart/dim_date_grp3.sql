{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

select
  invoice_date as date,
  toYear(invoice_date) as year,
  toQuarter(invoice_date) as quarter,
  CONCAT('Q', quarter) AS quarter_name,
  toMonth(invoice_date) as month,
  CASE
    WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
    WHEN month = 12 THEN 'December'
  END AS month_name
from {{ ref('stg_chinook__invoice_grp3') }}