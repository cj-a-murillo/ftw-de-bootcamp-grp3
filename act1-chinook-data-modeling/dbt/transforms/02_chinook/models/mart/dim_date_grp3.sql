{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

WITH calendar AS (
  SELECT
    formatDateTime(toDate('2021-01-01') + number, '%Y%m%d') AS date_key,
    toDate('2021-01-01') + number AS date,
    toYear(toDate('2021-01-01') + number) AS year,
    toMonth(toDate('2021-01-01') + number) AS month,
    toQuarter(toDate('2021-01-01') + number) AS quarter
  FROM numbers(1826)
)

SELECT * FROM calendar
