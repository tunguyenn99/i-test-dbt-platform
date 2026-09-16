select
    app_id,
    game_name,
    subtitle,
    app_url,
    icon_url,
    description,
    developer,
    age_rating,
    languages,
    language_count,
    primary_genre,
    genres,
    release_date
from {{ ref('stg_games') }}
