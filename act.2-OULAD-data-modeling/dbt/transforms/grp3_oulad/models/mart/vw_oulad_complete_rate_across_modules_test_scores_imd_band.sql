{{
    config(
        materialized='view',
        tags=['analytics', 'completion_rate', 'demographics']
    )
}}

WITH completion_metrics AS (
    SELECT 
        c.code_module AS module_code,           
        imd.imd_band AS imd_band,              
        fr.final_result AS final_result,       
        COUNT(*) AS student_count
    FROM {{ ref('fact_oulad_student_course_result_grp3') }} AS fact
    JOIN {{ ref('dim_oulad_student_grp3') }} AS student 
        ON fact.student_id = student.student_id
    JOIN {{ ref('dim_oulad_final_result_grp3') }} AS fr 
        ON fact.final_result_id = fr.final_result_id
    JOIN {{ ref('dim_oulad_imd_band_grp3') }} AS imd 
        ON student.imd_band_id = imd.imd_band_id
    JOIN {{ ref('dim_oulad_courses_grp3') }} AS c
        ON fact.course_id = c.course_id
    WHERE imd.imd_band != '?'
    {% if var('module_code', none) is not none %}
        AND c.code_module = '{{ var('module_code') }}'
    {% endif %}
    GROUP BY c.code_module, imd.imd_band, fr.final_result
)

SELECT 
    module_code,
    imd_band,
    final_result,
    student_count,
    ROUND(student_count * 100.0 / SUM(student_count) 
          OVER (PARTITION BY module_code, imd_band), 1) AS percentage
FROM completion_metrics
ORDER BY module_code, imd_band, student_count DESC