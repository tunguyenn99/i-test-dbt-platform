with yearly as (
    select
        f.release_year,
        d.primary_genre,
        count(*) as game_count,
        round(avg(average_user_rating), 2) as average_rating,
        sum(user_rating_count) as total_rating_count
        from {{ ref('fct_games') }} f
        join {{ ref('dim_game') }} d using (app_id)
        where f.release_year is not null
            and d.primary_genre is not null
        group by f.release_year, d.primary_genre
)

select
    release_year,
    primary_genre,
    game_count,
    average_rating,
    total_rating_count,
    game_count - lag(game_count) over (
        partition by primary_genre order by release_year
    ) as game_count_change_yoy
from yearly
