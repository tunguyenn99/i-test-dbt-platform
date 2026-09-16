with source_games as (
    select *
    from {{ source('mobile_games', 'games') }}
),

cleaned as (
    select
        app_id,
        {{ clean_text('name') }} as game_name,
        {{ clean_text('subtitle') }} as subtitle,
        app_url,
        icon_url,
        description,
        cast(average_user_rating as numeric(4, 2)) as average_user_rating,
        cast(user_rating_count as bigint) as user_rating_count,
        cast(price_usd as numeric(10, 2)) as price_usd,
        {{ clean_text('developer') }} as developer,
        {{ clean_text('age_rating') }} as age_rating,
        languages,
        {{ count_delimited_values('languages') }} as language_count,
        round(cast(size_in_bytes as numeric) / 1048576, 2) as size_mb,
        {{ clean_text('primary_genre') }} as primary_genre,
        genres,
        release_date,
        case when coalesce(price_usd, 0) = 0 then 'free' else 'paid' end as monetization_type
    from source_games
)

select *
from cleaned
where app_id is not null
    and game_name is not null
