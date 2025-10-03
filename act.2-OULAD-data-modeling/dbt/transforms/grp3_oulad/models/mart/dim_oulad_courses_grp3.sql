{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    course_id,
    code_module,
    code_presentation,
    presentation_year,
    presentation_code,
    module_presentation_length
from {{ source('clean', 'stg_oulad_course_grp3') }}
