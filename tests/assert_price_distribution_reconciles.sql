with check_totals as (
    select
        (select sum(game_count) from {{ ref('mart_price_distribution') }}) as mart_games,
        (select count(*) from {{ ref('fct_games') }}) as fact_games,
        (select sum(game_share_percent) from {{ ref('mart_price_distribution') }}) as share_percent
)

select *
from check_totals
where mart_games <> fact_games
   or share_percent < 99.90
   or share_percent > 100.10
