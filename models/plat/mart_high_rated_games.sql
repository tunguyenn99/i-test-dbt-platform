select
    app_id,
    d.game_name,
    d.primary_genre,
    d.developer,
    f.average_user_rating,
    f.user_rating_count,
    f.price_usd,
    f.release_date,
    row_number() over (
        order by f.average_user_rating desc, f.user_rating_count desc, f.app_id
    ) as rating_rank
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where f.average_user_rating is not null
  and f.user_rating_count >= 100
order by rating_rank
limit 20
