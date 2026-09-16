with check_totals as (
    select
        (select sum(game_count) from {{ ref('mart_release_yearly') }}) as mart_games,
        (select count(*) from {{ ref('fct_games') }} where release_year is not null) as fact_games
)

select *
from check_totals
where mart_games <> fact_games
