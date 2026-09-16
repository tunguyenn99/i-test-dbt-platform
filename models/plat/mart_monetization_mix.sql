select
    monetization_type,
    count(*) as game_count,
    round({{ safe_divide('100.0 * count(*)', 'sum(count(*)) over ()') }}, 2) as game_share_percent,
    round(avg(average_user_rating), 2) as average_rating,
    round(avg(user_rating_count), 2) as average_review_count,
    sum(user_rating_count) as total_review_count
from {{ ref('fct_games') }}
group by monetization_type
