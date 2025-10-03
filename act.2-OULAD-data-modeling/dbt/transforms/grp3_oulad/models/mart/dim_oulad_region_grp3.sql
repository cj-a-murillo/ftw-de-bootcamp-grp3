{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    region_id,
    region
from {{ source('clean', 'stg_oulad_region_grp3') }}
