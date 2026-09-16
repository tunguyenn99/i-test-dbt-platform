select
    case
        when size_mb < 50 then 'Small (<50 MB)'
        when size_mb < 200 then 'Medium (50-200 MB)'
        else 'Large (200+ MB)'
    end as size_bucket,
    count(*) as game_count,
    round(avg(size_mb), 2) as average_size_mb,
    round(avg(average_user_rating), 2) as average_rating,
    round(avg(user_rating_count), 2) as average_review_count
from {{ ref('fct_games') }}
where size_mb is not null
group by 1
order by min(case
    when size_mb < 50 then 1
    when size_mb < 200 then 2
    else 3
end)
