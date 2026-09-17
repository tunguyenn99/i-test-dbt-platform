# Platinum Layer (Business Analytics Marts)

The Platinum layer contains curated, high-performance analytical data marts specifically tailored to answer executive and analyst research questions (Q1 through Q15 in [`BUSINESS REQUIREMENTS.md`](../../BUSINESS%20REQUIREMENTS.md)).

## Directory Contents

| Model | Business Question | Description |
| :--- | :--- | :--- |
| [`mart_monetization_mix.sql`](mart_monetization_mix.sql) | **Q1** | Free vs. paid catalog mix, rating volume, and average rating comparisons. |
| [`mart_price_distribution.sql`](mart_price_distribution.sql) | **Q5** | Pricing tiers, common price points ($0.99, $1.99, $2.99, $4.99+), and volume shares. |
| [`mart_games_2019.sql`](mart_games_2019.sql) | **Q4** | Game releases in peak year 2019 categorized by primary genre. |
| [`mart_age_rating_genre.sql`](mart_age_rating_genre.sql) | **Q7** | Age rating distribution matrix (`4+`, `9+`, `12+`, `17+`) across primary genres. |
| [`mart_genre_language_benchmarks.sql`](mart_genre_language_benchmarks.sql) | **Q9** | Average supported language count and localization breadth by genre. |
| [`mart_high_rated_games.sql`](mart_high_rated_games.sql) | **Q6** | Top-rated games ($\ge 4.5$ stars) with significant market review volume ($\ge 100$ reviews). |
| [`mart_top_games_by_genre.sql`](mart_top_games_by_genre.sql) | **Q11** | Top 3 highest-rated games per genre filtered by credibility threshold. |
| [`mart_developer_consistency.sql`](mart_developer_consistency.sql) | **Q13** | Developer portfolio consistency measuring standard deviation of ratings (min. 3 games). |
| [`mart_size_rating_buckets.sql`](mart_size_rating_buckets.sql) | **Q14** | Application size buckets (Small $<50\text{MB}$, Medium $50\text{--}200\text{MB}$, Large $>200\text{MB}$) vs rating performance. |
| [`mart_genre_tags.sql`](mart_genre_tags.sql) | **Q15** | Frequency analysis of multi-valued genre tag combinations and co-occurrences. |
| [`mart_description_search.sql`](mart_description_search.sql) | **Q10** | Search-optimized table with sanitized descriptions, keywords, and popularity ranks. |
| [`mart_release_yearly.sql`](mart_release_yearly.sql) | **Q12** | Annual release volume, average ratings, and year-over-year (YoY) percentage growth. |
| [`mart_genre_performance.sql`](mart_genre_performance.sql) | **General** | Cross-genre performance benchmarks (average ratings, sizes, prices, and review volume). |
| [`mart_developer_benchmarks.sql`](mart_developer_benchmarks.sql) | **General** | Developer portfolio benchmarking: catalog count, average ratings, and market presence. |
| [`plat.yml`](plat.yml) | **Documentation** | Schema documentation and column descriptions for all Platinum marts. |

## Materialization & Strategy

- **Materialization**: `table`
- **Target Schema**: `plat`
- **Optimization**: Materializing these marts as permanent tables pre-computes complex groupings, window functions, and cross-layer joins so that downstream tools like **dbt Charts** can query them with sub-second response times.
