{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}


SELECT 
    c.code_module,
    c.code_presentation,
    SUM(scr.withdrawn_flag) AS withdrawn,
    COUNT(*) AS total_students,
    ROUND(SUM(scr.withdrawn_flag) * 100.0 / COUNT(*), 2) AS withdrawal_rate
FROM {{ source('mart', 'fact_oulad_student_course_result_grp3') }} scr 
JOIN  {{ source('mart', 'dim_oulad_courses_grp3') }}  c ON scr.course_id = c.course_id
GROUP BY c.code_module, c.code_presentation
ORDER BY withdrawal_rate DESC
