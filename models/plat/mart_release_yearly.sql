with yearly as (
    select
        release_year,
        count(*) as game_count,
        round(avg(average_user_rating), 2) as average_rating,
        sum(user_rating_count) as total_review_count
    from {{ ref('fct_games') }}
    where release_year is not null
    group by release_year
)

select
    release_year,
    game_count,
    average_rating,
    total_review_count,
    game_count - lag(game_count) over (order by release_year) as game_count_change_yoy,
    round(
        100.0 * (game_count - lag(game_count) over (order by release_year))
        / nullif(lag(game_count) over (order by release_year), 0),
        2
    ) as game_count_growth_percent
from yearly
order by release_year
