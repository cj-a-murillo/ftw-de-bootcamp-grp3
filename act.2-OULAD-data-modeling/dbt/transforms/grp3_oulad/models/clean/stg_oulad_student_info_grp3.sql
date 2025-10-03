{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

--table name: studentInfo
with base as (
	select * 
	from {{source('raw', 'oulad_grp3___student_info')}}
 	order by id_student

)
select
	cast(a.id_student as Nullable(Int64)) as student_id,
	cast(c.course_id as Nullable(Int64)) as course_id,
    cast(r.region_id as Nullable(Int64)) as region_id,
    cast(he.highest_educ_id as Nullable(Int64)) as highest_educ_id,
    cast(ib.imd_band_id as Nullable(Int64)) as imd_band_id,
    cast(age.age_band_id as Nullable(Int64)) as age_band_id,
    cast(fn.final_result_id as Nullable(Int64)) as final_result_id,
    cast(a.gender as Nullable(String)) as gender,
    cast(a.num_of_prev_attempts as Nullable(Int64)) as num_of_prev_attempts,
    cast(a.studied_credits as Nullable(Int64)) as studied_credits,
    cast(a.disability as Nullable(String)) as disability
from base a
left join {{ref ('stg_oulad_course_grp3')}} as c
	on a.code_module = c.code_module	
		and a.code_presentation = c.code_presentation
left join {{ref ('stg_oulad_region_grp3')}} as r
    on a.region = r.region
left join {{ref ('stg_oulad_highest_educ_grp3')}} as he 
    on a.highest_education = he.highest_education
left join {{ref ('stg_oulad_imd_band_grp3')}} as ib 
    on a.imd_band = ib.imd_band
left join {{ref('stg_oulad_age_band_grp3')}} as age 
    on a.age_band = age.age_band
left join {{ref('stg_oulad_final_result_grp3')}} as fn 
    on a.final_result = fn.final_result
