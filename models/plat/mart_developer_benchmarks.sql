select
    developer,
    count(*) as game_count,
    round(avg(average_user_rating), 2) as average_rating,
    sum(user_rating_count) as total_rating_count,
    round(avg(size_mb), 2) as average_size_mb,
    min(f.release_date) as first_release_date,
    max(f.release_date) as latest_release_date
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.developer is not null
group by d.developer
