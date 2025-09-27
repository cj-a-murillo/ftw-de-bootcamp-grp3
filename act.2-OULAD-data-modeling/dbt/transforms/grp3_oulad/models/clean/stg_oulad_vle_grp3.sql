{{ config(materialized="table", schema="sandbox") }}

-- Source columns are already Nullable with correct types.
-- Keep them as-is to preserve nullability and avoid insert errors.


select
	cast(id_site as Nullable(Int64)) as id_site,
	cast(code_module as Varchar(40)) as code_module,
	cast(code_presentation as Varchar(40)) as code_presentation,
	toInt64OrZero(week_from) as week_from,
	toInt64OrZero(week_to) as week_to
from {{ source('raw', 'oulad_grp3___vle') }}



