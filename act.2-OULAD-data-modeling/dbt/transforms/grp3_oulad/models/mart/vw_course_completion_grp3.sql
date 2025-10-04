{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}


SELECT 
    final_result as final_result,
    COUNT(*) as student_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) as percentage
from {{ source('mart', 'fact_oulad_student_course_result_grp3') }} fscr
JOIN  {{ source('mart', 'dim_oulad_final_result_grp3') }} fr
    ON fscr.final_result_id = fr.final_result_id
GROUP BY final_result
ORDER BY student_count DESC