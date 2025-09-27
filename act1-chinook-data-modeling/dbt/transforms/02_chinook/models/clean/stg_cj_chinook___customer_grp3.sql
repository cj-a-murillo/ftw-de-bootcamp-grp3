{{ config( materialized = "table", schema = "clean", tags = ["staging", "chinook"]) }}

select
  -- Enforce non-nullable customer_id (primary key)
  cast(customer_id as Int64) as customer_id,

  cast(COALESCE(first_name,'') as String) as first_name,
  cast(COALESCE(last_name,'')  as String) as last_name,

  -- Company name is optional; keep as nullable
  cast(COALESCE(company, '') as String) as company,

  cast(COALESCE(address,'') as String) as address,
  cast(COALESCE(city,'')    as String) as city,

  -- Replace NULL state values with blank string; not all countries use states
  cast(COALESCE(state, '') as String) as state,

  -- Country is usually present;
  cast(country as String) as country,

  cast(COALESCE(postal_code, '') as String) as postal_code,

  cast(COALESCE(phone, '') as String) as phone,

  cast(COALESCE(fax, '') as String) as fax,

  cast(COALESCE(email,'') as String) as email,

  cast(support_rep_id as Int64) as support_rep_id

from {{ source('raw', 'chinook_cj___customers') }}
