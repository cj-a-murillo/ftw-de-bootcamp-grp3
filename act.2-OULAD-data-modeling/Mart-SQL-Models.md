# Mart SQL Models

# Dimensions
- [dim_oulad_student_grp3.sql](#dim_oulad_student_grp3sql)
- [dim_oulad_age_band_grp3.sql](#dim_oulad_age_band_grp3sql)
- [dim_oulad_assessment_type_grp3.sql](#dim_oulad_assessment_type_grp3sql)
- [dim_oulad_course_grp3.sql](#dim_oulad_course_grp3sql)
- [dim_oulad_final_result_grp3.sql](#dim_oulad_final_result_grp3sql)
- [dim_oulad_highest_education_grp3.sql](#dim_oulad_highest_education_grp3sql)
- [dim_oulad_imd_band_grp3.sql](#dim_oulad_imd_band_grp3sql)
- [dim_oulad_region_grp3.sql](#dim_oulad_region_grp3sql)

# Facts
- [fact_oulad_student_course_result_grp3.sql](#fact_oulad_student_course_result_grp3sql)
- [fact_oulad_student_assessment_grp3.sql](#fact_oulad_student_assessment_grp3sql)


## dim_oulad_student_grp3.sql
```sql
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
```


## dim_oulad_age_band_grp3.sql
```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    age_band_id,
    age_band
from {{ source('clean', 'stg_oulad_age_band_grp3') }}
````

---

## dim_oulad_assessment_type_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    assessment_type_id,
    assessment_type
from {{ source('clean', 'stg_oulad_assessment_type_grp3') }}
```

---

## dim_oulad_course_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    course_id,
    code_module,
    code_presentation,
    presentation_year,
    presentation_code,
    module_presentation_length
from {{ source('clean', 'stg_oulad_course_grp3') }}
```

---

## dim_oulad_final_result_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    final_result_id,
    final_result
from {{ source('clean', 'stg_oulad_final_result_grp3') }}
```

---

## dim_oulad_highest_education_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    highest_educ_id,
    highest_education
from {{ source('clean', 'stg_oulad_highest_educ_grp3') }}
```

---

## dim_oulad_imd_band_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    imd_band_id,
    imd_band
from {{ source('clean', 'stg_oulad_imd_band_grp3') }}
```

---

## dim_oulad_region_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["dimension","grp3"]) }}

select
    region_id,
    region
from {{ source('clean', 'stg_oulad_region_grp3') }}
```

---

## fact_oulad_student_assessment_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["fact","grp3"]) }}

select 
    sa.student_id as student_id,
    a.assessment_id as assessment_id,
    a.course_id as course_id,
    a.assessment_type_id as assessment_type_id,
    a.assessment_date as assessment_date,
    a.assessment_weight as assessment_weight,
    sa.date_submitted as date_submitted,
    sa.is_banked as is_banked,
    sa.score as score
from {{ source('clean', 'stg_oulad_student_assessment_grp3') }} sa
join {{ source('clean', 'stg_oulad_assessment_grp3') }} a  
    on sa.assessment_id = a.assessment_id
order by student_id, assessment_id
```

---

## fact_oulad_student_course_result_grp3.sql

```sql
{{ config(materialized="table", schema="mart", tags=["fact","grp3"]) }}

select 
    sr.student_id as student_id,
    sr.course_id as course_id,
    c.code_module as code_module,
    c.code_presentation as code_presentation,
    si.final_result_id as final_result_id,
    
    -- Flags
    case when si.final_result_id = 1 then 1 else 0 end as withdrawn_flag,
    case when si.final_result_id = 2 then 1 else 0 end as fail_flag,
    case when si.final_result_id in (3,4) then 1 else 0 end as pass_flag
from {{ source('clean', 'stg_oulad_student_registration_grp3') }} sr
join {{ source('clean', 'stg_oulad_course_grp3') }} c
    on sr.course_id = c.course_id
join {{ source('clean', 'stg_oulad_student_info_grp3') }} si
    on sr.student_id = si.student_id
    and sr.course_id = si.course_id
order by sr.course_id, sr.student_id
```







