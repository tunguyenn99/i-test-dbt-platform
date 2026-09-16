select
    d.developer,
    count(*) as game_count,
    round(avg(average_user_rating), 2) as average_rating,
    round(stddev_pop(average_user_rating), 3) as rating_stddev,
    sum(user_rating_count) as total_review_count,
    round(
        {{ safe_divide(
            '100.0 * count(*) filter (where f.average_user_rating >= 4.0)',
            'count(*) filter (where f.average_user_rating is not null)'
        ) }},
        2
    ) as percent_games_rating_4_plus
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.developer is not null
group by d.developer
having count(*) >= 3
    and count(f.average_user_rating) >= 3
order by rating_stddev asc nulls last, total_review_count desc
