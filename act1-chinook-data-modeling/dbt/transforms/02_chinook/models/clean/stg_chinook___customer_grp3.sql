{{ config( materialized = "table", schema = "clean", tags = ["staging", "chinook"]) }}

select
  cast(customer_id    as Nullable(Int64))  as customer_id,
  cast(first_name     as Nullable(String)) as first_name,
  cast(last_name      as Nullable(String)) as last_name,
  cast(company        as Nullable(String)) as company,
  cast(address        as Nullable(String)) as address,
  cast(city           as Nullable(String)) as city,
  cast(state          as Nullable(String)) as state,
  cast(country        as Nullable(String)) as country,
  cast(postal_code    as Nullable(String)) as postal_code,
  cast(phone          as Nullable(String)) as phone,
  cast(fax            as Nullable(String)) as fax,
  cast(email          as Nullable(String)) as email,
  cast(support_rep_id as Nullable(Int64))  as support_rep_id

from {{ source('raw', 'chinook_grp3___customers') }}
