{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    age_band_id,
    age_band
from {{ source('clean', 'stg_oulad_age_band_grp3') }}
