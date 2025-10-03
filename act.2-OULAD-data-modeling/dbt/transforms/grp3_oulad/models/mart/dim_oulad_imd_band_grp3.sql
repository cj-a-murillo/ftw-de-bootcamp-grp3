{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    imd_band_id,
    imd_band
from {{ source('clean', 'stg_oulad_imd_band_grp3') }}
