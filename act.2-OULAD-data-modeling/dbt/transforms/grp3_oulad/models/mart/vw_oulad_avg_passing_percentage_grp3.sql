{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}


select 
    code_module,
    code_presentation,
    round(100.0 * sum(pass_flag) / count(*), 2) as passing_percentage
from {{ source('mart', 'fact_oulad_student_course_result_grp3') }} fscr 
group by code_module, code_presentation
order by code_module, code_presentation
