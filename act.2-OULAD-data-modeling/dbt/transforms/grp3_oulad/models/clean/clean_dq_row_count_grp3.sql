{{ config(materialized="table", schema="clean", tags=["staging", "oulad"]) }}

SELECT 'age_band' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_age_band_grp3') }}

UNION ALL

SELECT 'assessment' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_assessment_grp3') }}

UNION ALL

SELECT 'assessment_type' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_assessment_type_grp3') }}

UNION ALL

SELECT 'course' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_course_grp3') }}

UNION ALL

SELECT 'final_result' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_final_result_grp3') }}

UNION ALL

SELECT 'highest_educ' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_highest_educ_grp3') }}

UNION ALL

SELECT 'imd_band' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_imd_band_grp3') }}

UNION ALL

SELECT 'region' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_region_grp3') }}

UNION ALL

SELECT 'student_assessment' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_student_assessment_grp3') }}

UNION ALL

SELECT 'student_info' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_student_info_grp3') }}

UNION ALL

SELECT 'student_registration' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_student_registration_grp3') }}

UNION ALL

SELECT 'vle' AS table_name, COUNT(*) AS row_count 
FROM {{ source('clean', 'stg_oulad_vle_grp3') }}

ORDER BY table_name