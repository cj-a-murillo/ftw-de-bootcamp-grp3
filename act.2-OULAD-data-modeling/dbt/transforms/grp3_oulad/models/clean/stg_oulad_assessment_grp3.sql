{{config(materialized = "table", schema = "sandbox", tags=["staging", "oulad"])}}

--table name: assessment
select
	cast(id_assessment as Nullable(Int64)) as assessment_id,
	cast(assessment_type as Nullable(Varchar(10))) as assessment_type,
	replace(cast(date as Nullable(String)), '?', '') as assessment_date
	cast(weight as Nullable(Int64)) as assessment_weight,
	cast(code_module as Nullable(Varchar(4))) as code_module,
	cast(code_presentation as Nullable(Varchar(5))) as code_presentation
 from {{source('raw', 'oulad_grp3___assessments')}}
 order by assessment_id
