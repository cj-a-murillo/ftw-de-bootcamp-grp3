{{config(materialized = "table", schema = "sandbox", tags=["staging", "oulad"])}}

--table name: assessment type (originated from assessment table)
with distinct_types as (
select DISTINCT 
  cast(assessment_type as Nullable(Varchar(10))) as assessment_type
 from {{source('raw', 'oulad_grp3___assessments')}}
)
select
	cast(row_number() over (order by assessment_type) as Int64) as assessment_type_id,
	assessment_type
from distinct_types