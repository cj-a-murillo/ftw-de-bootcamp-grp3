{{ config(materialized="table", schema="clean", tags=["staging","chinook"]) }}

-- Standardize column names/types per table; no business logic.
select
  cast(employee_id                as Int64)            as employee_id,
  cast(last_name                  as String)     as last_name,
  cast(first_name                 as String)     as first_name,
  cast(COALESCE(title,'')         as String)     as title,
  cast(reports_to    as Nullable(Int64))            as reports_to,
  cast(birth_date    as Nullable(DateTime))        as birth_date,
  cast(hire_date    as Nullable(DateTime))        as hire_date,
  cast(COALESCE(address,'')       as String)     as address,
  cast(COALESCE(city,'')          as String)     as city,
  cast(COALESCE(state,'')         as String)     as state,
  cast(COALESCE(country,'')       as String)     as country,
  cast(COALESCE(postal_code,'')   as String)     as postal_code,
  cast(COALESCE(phone,'')         as String)     as phone,
  cast(COALESCE(fax,'')           as String)     as fax,
  cast(COALESCE(email,'')         as String)     as email
from {{ source('raw', 'chinook_cj___employees') }}