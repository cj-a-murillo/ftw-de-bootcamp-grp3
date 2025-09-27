{{ config(materialized="table", schema="mart", tags=["mart","chinook"]) }}

-- Album dimension, denormalized with artist_name (common convenience).
select
  album_id,
  album_title
from {{ ref('stg_chinook__album_grp3') }}


/* Pwede pa mabago ito joins, lalo na kung mag-snowflake 
pwede hiwalay na lang na dimensions yung artist at album.  */

/* PWede ilagay na lng yun IDs sa fact table para hindi mag-snowflake */

/* Maganda na kay fact table na lang lahat ng ID and siya na ang mag-join sa lahat para
hindi ma-duplicate yung data.  */

/*Treat all dimensions as separate clean entity without other attribbutes,
kumbaga kung ano lang yun attributes related sa dimension table na yun ay ayun nalang ang isama
sa dimension table.  (ex: wala na dapat artist_name sa table, dapat separate DIM table na lang yun */

/* If you want to denormalize, pwede naman, pero mas maganda na lang separate tables
para hindi ma-duplicate yung data.  */

/* Maganda na lang na sa fact table na lang lahat ng IDs para hindi ma-duplicate yung data.  */

