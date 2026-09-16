select
    d.primary_genre,
    count(*) as game_count,
    round(avg(language_count), 2) as average_language_count,
    max(language_count) as max_language_count
from {{ ref('fct_games') }} f
join {{ ref('dim_game') }} d using (app_id)
where d.primary_genre is not null
group by d.primary_genre
order by average_language_count desc
