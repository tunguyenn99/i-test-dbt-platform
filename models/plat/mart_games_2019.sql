select
    primary_genre,
    count(*) as game_count,
    round(avg(average_user_rating), 2) as average_rating,
    sum(user_rating_count) as total_review_count
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where f.release_year = 2019
  and d.primary_genre is not null
group by d.primary_genre
order by game_count desc
