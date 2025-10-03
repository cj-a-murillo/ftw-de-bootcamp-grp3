{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--from studentinfo table
with distinct_imd_band as (
select DISTINCT 
  trim(cast(imd_band as Nullable(String))) as imd_band
 from {{source('raw', 'oulad_grp3___student_info')}}
)
select
	cast(row_number() over (order by imd_band) as Int64) as imd_band_id,
	imd_band
from distinct_imd_band