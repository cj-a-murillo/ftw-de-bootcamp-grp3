{{ config(materialized="view", schema="mart", tags=["dimension","grp3"]) }}


SELECT 
    c.code_module,
    c.code_presentation,
    atype.assessment_type,
    fr.final_result,
    COUNT(*) AS student_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) 
          OVER (PARTITION BY c.code_module, c.code_presentation, atype.assessment_type), 1) AS percentage
FROM {{ source('mart', 'fact_oulad_student_assessment_grp3') }}  fa
JOIN {{ source('mart', 'dim_oulad_assessment_type_grp3') }}   atype
    ON fa.assessment_type_id = atype.assessment_type_id
JOIN {{ source('mart', 'fact_oulad_student_course_result_grp3') }}  scr 
    ON fa.student_id = scr.student_id 
   AND fa.course_id = scr.course_id
JOIN {{ source('mart', 'dim_oulad_courses_grp3') }}  c 
    ON scr.course_id = c.course_id
JOIN {{ source('mart', 'dim_oulad_final_result_grp3') }}  fr 
    ON scr.final_result_id = fr.final_result_id
GROUP BY c.code_module, c.code_presentation, atype.assessment_type, fr.final_result
ORDER BY c.code_module, atype.assessment_type, percentage DESC