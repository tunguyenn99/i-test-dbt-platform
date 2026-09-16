select
    primary_genre,
    count(*) as game_count,
    round(avg(average_user_rating), 2) as average_rating,
    sum(user_rating_count) as total_rating_count,
    round(avg(user_rating_count), 2) as average_rating_count,
    round(avg(size_mb), 2) as average_size_mb,
    round(avg(price_usd), 2) as average_price_usd,
    count(*) filter (where monetization_type = 'free') as free_game_count,
    count(*) filter (where monetization_type = 'paid') as paid_game_count
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.primary_genre is not null
group by d.primary_genre
