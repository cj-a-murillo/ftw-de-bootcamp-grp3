{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}

SELECT 
    c.code_module AS module_code,
    c.code_presentation AS module_presentation,
    COUNT(*) AS total_assessments,
    SUM(CASE WHEN fa.score < 40 THEN 1 ELSE 0 END) AS below_pass_count,
    ROUND(SUM(CASE WHEN fa.score < 40 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_below_pass
FROM {{ source('mart', 'fact_oulad_student_assessment_grp3') }} fa
JOIN {{ source('mart', 'dim_oulad_courses_grp3') }} c
    ON fa.course_id = c.course_id
WHERE fa.score IS NOT NULL
GROUP BY c.code_module, c.code_presentation
ORDER BY pct_below_pass DESC