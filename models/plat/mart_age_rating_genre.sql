select
    d.age_rating,
    d.primary_genre,
    count(*) as game_count
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.age_rating is not null
  and d.primary_genre is not null
group by d.age_rating, d.primary_genre
