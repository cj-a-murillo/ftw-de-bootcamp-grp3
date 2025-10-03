{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    highest_educ_id,
    highest_education
from {{ source('clean', 'stg_oulad_highest_educ_grp3') }}
