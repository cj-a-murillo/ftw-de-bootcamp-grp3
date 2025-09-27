{{ config( materialized = "table", schema = "clean", tags = ["staging", "chinook"]) }}

select
  -- Enforce non-nullable customer_id (primary key)
  cast(customer_id as Int64) as customer_id,

  cast(first_name as String) as first_name,
  cast(last_name  as String) as last_name,

  -- Company name is optional; keep as nullable
  cast(company as Nullable(String)) as company,

  cast(address as Nullable(String))      as address,
  cast(city as Nullable(String))         as city,

  -- Keep as nullable; not all countries use states
  cast(state as Nullable(String))        as state,

  -- Country is usually present;
  cast(country as String) as country,

  cast(postal_code as Nullable(String))  as postal_code,
  cast(phone as Nullable(String))        as phone,
  cast(fax as Nullable(String))          as fax,

  -- Based on the public dataset, the email and the support_rep is required for the invoice transaction.
  cast(email as String)        as email,
  cast(support_rep_id as Int64) as support_rep_id

from {{ source('raw', 'chinook_grp3___customers') }}
