{{ config(materialized="table", schema="mart", tags=["fact","grp3"]) }}

select 
    sr.student_id as student_id,
    sr.course_id as course_id,
    c.code_module as code_module,
    c.code_presentation as code_presentation,
    si.final_result_id as final_result_id,
    
    -- Flags
    case when si.final_result_id = 1 then 1 else 0 end as withdrawn_flag,
    case when si.final_result_id = 2 then 1 else 0 end as fail_flag,
    case when si.final_result_id in (3,4) then 1 else 0 end as pass_flag
from {{ source('clean', 'stg_oulad_student_registration_grp3') }} sr
join {{ source('clean', 'stg_oulad_course_grp3') }} c
    on sr.course_id = c.course_id
join {{ source('clean', 'stg_oulad_student_info_grp3') }} si
    on sr.student_id = si.student_id
    and sr.course_id = si.course_id
order by sr.course_id, sr.student_id