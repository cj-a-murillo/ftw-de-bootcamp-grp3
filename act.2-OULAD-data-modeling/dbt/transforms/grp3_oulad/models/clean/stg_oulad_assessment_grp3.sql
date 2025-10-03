{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--table name: assessment
with base as (
	select * 
	from {{source('raw', 'oulad_grp3___assessments')}}
 	order by id_assessment

)
select
	cast(a.id_assessment as Nullable(Int64)) as assessment_id,
	cast(c.course_id as Nullable(Int64)) as course_id,
	cast(t.assessment_type_id as Nullable(Int64)) as assessment_type_id,
	replace(cast(a.date as Nullable(String)), '?', '') as assessment_date,
	cast(a.weight as Nullable(Int64)) as assessment_weight
 from base a
 left join {{ref ('stg_oulad_assessment_type_grp3')}} as t 
	on a.assessment_type = t.assessment_type
left join {{ref ('stg_oulad_course_grp3')}} as c
	on a.code_module = c.code_module	
		and a.code_presentation = c.code_presentation
