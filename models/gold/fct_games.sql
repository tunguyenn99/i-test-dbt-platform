select
    app_id,
    average_user_rating,
    user_rating_count,
    price_usd,
    size_mb,
    release_date,
    extract(year from release_date)::int as release_year,
    monetization_type
from {{ ref('stg_games') }}
