{{ config(materialized="table", schema="mart", tags=["oulad"]) }}

SELECT 'dim_oulad_age_band_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_age_band_grp3') }}

UNION ALL
SELECT 'dim_oulad_assessment_type_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_assessment_type_grp3') }}

UNION ALL
SELECT 'dim_oulad_courses_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_courses_grp3') }}

UNION ALL
SELECT 'dim_oulad_final_result_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_final_result_grp3') }}

UNION ALL
SELECT 'dim_oulad_highest_education_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_highest_education_grp3') }}

UNION ALL
SELECT 'dim_oulad_imd_band_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_imd_band_grp3') }}

UNION ALL
SELECT 'dim_oulad_region_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_region_grp3') }}

UNION ALL
SELECT 'dim_oulad_student_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'dim_oulad_student_grp3') }}

UNION ALL
SELECT 'fact_oulad_student_course_result_grp3' AS table_name, COUNT(*) AS row_count 
FROM {{ source('mart', 'fact_oulad_student_course_result_grp3') }}

ORDER BY table_name
