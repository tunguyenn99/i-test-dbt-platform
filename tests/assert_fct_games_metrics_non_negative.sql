select app_id
from {{ ref('fct_games') }}
where user_rating_count < 0
   or price_usd < 0
   or size_mb < 0
