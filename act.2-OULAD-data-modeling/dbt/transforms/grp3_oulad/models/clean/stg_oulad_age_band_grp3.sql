{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--from studentinfo table
with distinct_age_band as (
select DISTINCT 
  trim(cast(age_band as Nullable(String))) as age_band
 from {{source('raw', 'oulad_grp3___student_info')}}
)
select
	cast(row_number() over (order by age_band) as Int64) as age_band_id,
	age_band
from distinct_age_band