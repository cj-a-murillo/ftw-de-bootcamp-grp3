{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--from studentinfo table
with distinct_region as (
select DISTINCT 
  trim(cast(region as Nullable(String))) as region
 from {{source('raw', 'oulad_grp3___student_info')}}
)
select
	cast(row_number() over (order by region) as Int64) as region_id,
	region
from distinct_region