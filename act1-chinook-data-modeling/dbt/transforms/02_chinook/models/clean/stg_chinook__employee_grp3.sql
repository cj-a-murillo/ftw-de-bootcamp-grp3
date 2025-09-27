{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(employee_id  as Int64)   as employee_id,
  cast(first_name as String)   as first_name,
  cast(last_name as String)    as last_name,
  cast(title as Nullable(String))        as title,
  cast(reports_to as Nullable(Int64))     as reports_to,
  cast(birth_date as Nullable(date))     as birth_date,
  cast(hire_date as Nullable(date))      as hire_date,
  cast(address as Nullable(String))      as address,
  cast(city as Nullable(String))         as city,
  cast(state as Nullable(String))        as state,
  cast(country as Nullable(String))      as country,
  cast(postal_code as Nullable(String))  as postal_code,
  cast(phone as Nullable(String))        as phone,
  cast(fax as Nullable(String))          as fax,
  cast(email as Nullable(String))        as email
from {{ source('raw', 'chinook_grp3___employees') }}