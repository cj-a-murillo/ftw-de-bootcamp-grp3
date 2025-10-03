{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    final_result_id,
    final_result
from {{ source('clean', 'stg_oulad_final_result_grp3') }}
