{{ config(materialized="table", schema="clean") }}

-- Source columns are already Nullable with correct types.
-- Keep them as-is to preserve nullability and avoid insert errors.

select
  toFloat64(mpg)          as mpg,
  toInt32(cylinders)      as cylinders,
  toFloat64(displacement) as displacement,
  toFloat64OrNull(horsepower)   as horsepower,
  toInt32(weight)         as weight,
  toFloat64(acceleration) as acceleration,
  toInt32(model_year)     as model_year,
  trim(origin)                  as origin,
  trim(name)                    as make
from {{ source('raw', 'autompg___cars') }}
-- where horsepower is not null
  -- and isFinite(horsepower)


