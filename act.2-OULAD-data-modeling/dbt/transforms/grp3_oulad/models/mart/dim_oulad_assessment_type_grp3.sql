{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    assessment_type_id,
    assessment_type
from {{ source('clean', 'stg_oulad_assessment_type_grp3') }}
