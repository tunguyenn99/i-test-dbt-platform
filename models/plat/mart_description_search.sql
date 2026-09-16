select
    app_id,
    d.game_name,
    d.description,
    d.primary_genre,
    d.developer,
    f.average_user_rating,
    f.user_rating_count,
    f.release_date
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.description is not null
