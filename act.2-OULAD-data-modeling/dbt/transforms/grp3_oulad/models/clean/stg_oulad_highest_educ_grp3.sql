{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--from studentinfo table
with distinct_highest_educ as (
select DISTINCT 
  trim(cast(highest_education as Nullable(String))) as highest_education
 from {{source('raw', 'oulad_grp3___student_info')}}
)
select
	cast(row_number() over (order by highest_education) as Int64) as highest_educ_id,
	highest_education
from distinct_highest_educ