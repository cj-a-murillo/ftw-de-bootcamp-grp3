{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}

SELECT 
    c.code_module,
    c.code_presentation,
    fr.final_result,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY c.code_module, c.code_presentation), 1) AS percentage
from {{ source('mart', 'fact_oulad_student_course_result_grp3') }} scr 
JOIN {{ source('mart', 'dim_oulad_courses_grp3') }} c
    ON scr.course_id = c.course_id
JOIN  {{ source('mart', 'dim_oulad_final_result_grp3') }}   fr 
    ON scr.final_result_id = fr.final_result_id
GROUP BY c.code_module, c.code_presentation, fr.final_result
ORDER BY percentage ASC