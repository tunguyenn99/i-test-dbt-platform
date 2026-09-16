with exploded_tags as (
    select
        d.app_id,
        trim(tag) as genre_tag
    from {{ ref('fct_games') }} f
    join {{ ref('dim_game') }} d using (app_id)
    cross join lateral regexp_split_to_table(coalesce(d.genres, ''), '\s*,\s*') as tag
)

select
    genre_tag,
    count(distinct app_id) as game_count,
    round({{ safe_divide('100.0 * count(distinct app_id)', 'sum(count(distinct app_id)) over ()') }}, 2) as tag_share_percent
from exploded_tags
where genre_tag is not null
  and genre_tag <> ''
group by genre_tag
order by game_count desc, genre_tag
limit 15
