with buckets as (
    select
        case
            when price_usd = 0 then '0 (free)'
            when price_usd > 0 and price_usd <= 1 then '0-1 USD'
            when price_usd > 1 and price_usd <= 5 then '1-5 USD'
            when price_usd > 5 and price_usd <= 20 then '5-20 USD'
            when price_usd > 20 then 'over 20 USD'
            else 'unknown'
        end as price_bucket
    from {{ ref('fct_games') }}
)

select
    price_bucket,
    count(*) as game_count,
    round({{ safe_divide('100.0 * count(*)', 'sum(count(*)) over ()') }}, 2) as game_share_percent
from buckets
group by price_bucket
order by case price_bucket
    when '0 (free)' then 1
    when '0-1 USD' then 2
    when '1-5 USD' then 3
    when '5-20 USD' then 4
    when 'over 20 USD' then 5
    else 6
end
