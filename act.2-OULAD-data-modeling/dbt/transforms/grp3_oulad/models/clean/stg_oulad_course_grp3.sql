{{config(materialized = "table", schema = "clean", tags=["staging", "oulad"])}}

select 
    cast(row_number() over (order by code_module, code_presentation) as Int64) as course_id,
    trim(cast(code_module as Nullable(String))) as code_module,
    trim(cast(code_presentation as Nullable(String))) as code_presentation,
    cast(substring(code_presentation, 1, 4) as Int64) as presentation_year,
    cast(substring(code_presentation, 5, 1) as String) as presentation_code,
    cast(module_presentation_length as Nullable(Int64)) as module_presentation_length
    from {{source('raw','oulad_grp3___courses')}}
    group by code_module, code_presentation, module_presentation_length
    order by course_id