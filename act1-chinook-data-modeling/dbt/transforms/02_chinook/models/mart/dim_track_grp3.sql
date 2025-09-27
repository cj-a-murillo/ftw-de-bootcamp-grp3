{{ config(materialized="table", schema="mart", tags=["mart", "chinook"]) }}

select
  track_id as track_id,
  name as track_name,
from {{ ref('stg_chinook__track_grp3') }}
