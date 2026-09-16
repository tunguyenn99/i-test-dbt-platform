select
    app_id,
    count(*) as row_count
from {{ ref('fct_games') }}
group by app_id
having count(*) <> 1
