with ranked as (
    select
        app_id,
                d.game_name,
                d.primary_genre,
                d.developer,
                f.average_user_rating,
                f.user_rating_count,
                f.release_date,
        row_number() over (
                        partition by d.primary_genre
                        order by f.average_user_rating desc, f.user_rating_count desc, f.app_id
        ) as genre_rank
        from {{ ref('fct_games') }} f
        join {{ ref('dim_game') }} d using (app_id)
        where d.primary_genre is not null
            and f.average_user_rating is not null
            and f.user_rating_count >= 100
)

select *
from ranked
where genre_rank <= 3
