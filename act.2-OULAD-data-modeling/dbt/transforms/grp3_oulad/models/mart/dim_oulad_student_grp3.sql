{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    si.student_id as student_id,
    si.gender as gender,
    si.disability as disability,
    si.num_of_prev_attempts as num_of_prev_attempts,
    si.studied_credits as studied_credits,
    si.region_id as region_id,
    si.highest_educ_id as highest_educ_id,
    si.imd_band_id as imd_band_id,
    si.age_band_id as age_band_id,
    r.region as region,
    he.highest_education as highest_education,
    ib.imd_band as imd_band,
    ab.age_band as age_band
    
from {{ source('clean', 'stg_oulad_student_info_grp3') }} si
left join {{ source('clean', 'stg_oulad_region_grp3') }} r
    on si.region_id = r.region_id
left join {{ source('clean', 'stg_oulad_highest_educ_grp3') }} he
    on si.highest_educ_id = he.highest_educ_id
left join {{ source('clean', 'stg_oulad_imd_band_grp3') }} ib
    on si.imd_band_id = ib.imd_band_id
left join {{ source('clean', 'stg_oulad_age_band_grp3') }} ab
    on si.age_band_id = ab.age_band_id