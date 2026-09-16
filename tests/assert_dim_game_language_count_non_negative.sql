select app_id
from {{ ref('dim_game') }}
where language_count < 0