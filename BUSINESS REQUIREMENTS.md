# Business Requirements

## 1. Document Control

| Item | Definition |
| --- | --- |
| Business domain | Mobile game market research |
| Business owner | Xom Arcade market research team |
| Primary users | Game publishers, indie developers, Head of Research, Tech Research Lead |
| Source | Xom Dataset `mobile_games.games` |
| Source URL | https://dataset.xomdata.com/datasets/schema/mobile_games |
| Grain | One row per App Store game (`app_id`) |
| Snapshot size | 16,847 rows and 16 columns at requirements capture time |
| Delivery style | Rankings, benchmarks, trends, and ad-hoc analysis |

## 2. Business Context

Xom Arcade provides market research for publishers and indie developers using a
snapshot of the App Store game catalog. The product must help clients understand
catalog composition, popularity, ratings, monetization, game size, genres,
developer portfolios, and release trends.

The data contains catalog metadata only. It does not contain transactions,
revenue, installs, retention, or player-level behavior. Therefore:

- `user_rating_count` is the proxy for popularity or market attention.
- `price_usd` is the proxy for monetization model and price positioning.
- Ratings describe user sentiment, not commercial success.
- Results must be presented as catalog benchmarks, not revenue claims.

## 3. Goals

1. Provide trusted rankings and benchmarks for genres and developers.
2. Compare free and paid games using review volume and ratings.
3. Identify release, rating, size, language, age-rating, and price patterns.
4. Support repeatable stakeholder questions through dbt models and dbt Charts.
5. Make every result reproducible from version-controlled SQL and YAML.

## 4. Scope

### In scope

- Fivetran replication from SQL Server `mobile_games.games` to Supabase Postgres.
- dbt Core staging, data quality tests, analytical marts, and documentation.
- dbt Charts boards for KPI, genre, developer, and release-trend reporting.
- The 15 ad-hoc stakeholder requests listed in this document.
- Filtering, aggregation, ranking, bucketing, window functions, string parsing,
  and descriptive benchmarking.

### Out of scope

- Revenue, sales, installs, retention, conversion, or profitability analysis.
- Causal claims such as "larger games cause higher ratings".
- User-level or session-level analysis.
- Joining to other tables; the source currently has no foreign keys.
- Automated App Store refresh beyond the configured Fivetran sync cadence.

## 5. Source Data Contract

Source table: `postgres.mobile_games.games` after Fivetran replication.

| Column | Source type | Nullable | Business meaning | Primary use |
| --- | --- | --- | --- | --- |
| `app_url` | nvarchar(500) | Yes | App Store URL | Record link |
| `app_id` | bigint | No | App Store identifier | Primary business key |
| `name` | nvarchar(255) | Yes | Game title | Game label |
| `subtitle` | nvarchar(500) | Yes | App Store subtitle | Catalog context |
| `icon_url` | nvarchar(500) | Yes | Game icon URL | Optional presentation |
| `average_user_rating` | decimal | Yes | Average user rating | Sentiment KPI |
| `user_rating_count` | int | Yes | Number of user ratings/reviews | Popularity proxy |
| `price_usd` | decimal | Yes | Listed price in USD | Monetization/price proxy |
| `description` | nvarchar | Yes | App Store description | Keyword analysis |
| `developer` | nvarchar(255) | Yes | Developer/publisher name | Portfolio analysis |
| `age_rating` | nvarchar(10) | Yes | Store age-rating label | Audience segmentation |
| `languages` | nvarchar | Yes | Supported language list | Localization analysis |
| `size_in_bytes` | bigint | Yes | Download size | Size analysis |
| `primary_genre` | nvarchar(100) | Yes | Main App Store genre | Primary grouping |
| `genres` | nvarchar(500) | Yes | All genre tags | Multi-tag analysis |
| `release_date` | date | Yes | App Store release date | Time analysis |

### Key and relationship rules

- `app_id` is the row-level key and must be unique in the replicated source.
- There are no declared foreign keys; analyses are based on one table.
- `name`, ratings, price, developer, genres, and release date are nullable in the
  source. Staging may exclude rows without an `app_id` or usable game name.
- Convert `size_in_bytes` to MB using `size_in_bytes / 1,048,576`.
- Treat `price_usd = 0` or null as `free` only after agreeing the null policy;
  the current staging model treats null price as free.

## 6. Stakeholder Questions and Acceptance Criteria

Every request must return the requested measure, grouping, ordering, and enough
row-level context to reproduce the result. Null and tie handling must be stated.

| ID | Requirement | Required output |
| --- | --- | --- |
| Q1 | Compare free versus paid games. | Count and percentage of games in each group. |
| Q2 | Find the most prolific developers/publishers. | Top 10 developers ranked by game count. |
| Q3 | Compare ratings and review volume by main genre. | Average rating and average review count per `primary_genre`. |
| Q4 | Measure studio output in 2019. | Number of games released in 2019 by genre. |
| Q5 | Show price distribution. | Counts and percentages for 0, 0-1 USD, 1-5 USD, 5-20 USD, and over 20 USD. |
| Q6 | Find highly rated games with meaningful engagement. | Top 20 games, filtered to a documented minimum review threshold, ranked by rating with review count as tie-breaker. |
| Q7 | Understand age-rating composition by genre. | Matrix/count table of `age_rating` by `primary_genre`. |
| Q8 | Compare game size by genre. | Average game size in MB by genre and the highest-size genre. |
| Q9 | Measure localization breadth. | Average number of supported languages per genre. |
| Q10 | Search games by a business keyword. | Count and list of games whose description contains the supplied keyword, case-insensitively. Keyword must be a runtime parameter. |
| Q11 | Identify the best games in each genre. | Top 3 games per genre, ranked by rating with documented tie-breakers and minimum review policy. |
| Q12 | Track release and quality trends. | Games released, average rating, and year-over-year growth by year. |
| Q13 | Identify consistent developers. | Developer portfolio quality using rating consistency, including game count and standard deviation; minimum portfolio size must be documented. |
| Q14 | Test size versus rating correlation. | Small `<50MB`, medium `50-200MB`, and large `200MB+` groups with average rating and sample size; describe association, not causation. |
| Q15 | Find the most popular genre tags. | Top 15 tags from the multi-valued `genres` field, counting games carrying each tag, not only `primary_genre`. |

### Metric policies

- Popularity ranking defaults to descending `user_rating_count`.
- Rating ranking must show sample size (`user_rating_count`) beside the rating.
- For averages, exclude null measures and show the contributing row count.
- For percentage distributions, use the valid catalog population as denominator
  and state whether null values are excluded.
- For year-over-year growth, the first observed year has no prior-year comparison
  and should return null rather than zero.
- For Q6 and Q11, the minimum-review threshold is a business parameter, not a
  hard-coded claim. The initial implementation must expose or document it.
- Developer and genre names must preserve the source label while trimming blank
  values. Case-normalization rules must be documented if applied.

## 7. Data Quality Requirements

The pipeline must:

1. Test `app_id` not null and unique at source, staging, and fact layers.
2. Keep only usable rows in `stg_games` (`app_id` and cleaned game name present).
3. Test `release_date` not null if year-over-year reporting is required.
4. Restrict `monetization_type` to `free` and `paid`.
5. Prevent negative prices, negative review counts, and negative sizes from being
   silently interpreted as valid measures.
6. Preserve raw source columns needed for audit and drill-through.
7. Report row counts removed by staging filters and null rates for key measures.
8. Make the Fivetran sync timestamp and source snapshot date available when the
   connector exposes them.

## 8. Technical Requirements

### Ingestion

- Source system: SQL Server at the Xom Dataset account.
- Source schema/table: `mobile_games.games`.
- Destination database: existing Supabase database `postgres`.
- Destination schema: `mobile_games`.
- IPv4-compatible Supabase Session Pooler should be used by Fivetran:
  `aws-0-ap-southeast-2.pooler.supabase.com:6543`.
- Pooler username must include the project reference, for example
  `fivetran.kttubuuzrfmzuzfepzjo`.

### Transformation

- dbt Core with the Postgres adapter.
- Silver relations in `analytics_silver`.
- Gold dimensions/facts in `analytics_gold`.
- Plat mart relations in `analytics_plat`.
- All models and tests must run with `dbt build`.
- Credentials must be supplied through `.env`/environment variables and never
  committed to Git.

### Reporting

- dbt Charts project config: `dbt_charts.yml`.
- Boards live under `charts/` and use the `analytics` dbt profile source.
- Charts must validate with `dct validate charts/`.
- Local preview uses `dct serve` after marts exist.

## 9. Current Implementation Mapping

| Requirement area | Current implementation | Status |
| --- | --- | --- |
| Raw source declaration | `models/bronze/sources.yml` | Implemented |
| Cleaned catalog | `models/silver/stg_games.sql` | Implemented |
| One-row-per-game dimension | `models/gold/dim_game.sql` | Implemented |
| One-row-per-game fact | `models/gold/fct_games.sql` | Implemented |
| Genre benchmarks | `models/plat/mart_genre_performance.sql` | Implemented |
| Developer benchmarks | `models/plat/mart_developer_benchmarks.sql` | Implemented |
| Release trends | `models/gold/int_release_trends.sql` | Implemented |
| Overview board | `charts/xom_arcade_overview.yml` | Implemented |
| Q1 free/paid distribution | `mart_monetization_mix` | Implemented |
| Q4 2019 release output | `mart_games_2019` | Implemented |
| Q5 price buckets | `mart_price_distribution` | Implemented |
| Q6 high-rated games | `mart_high_rated_games` | Implemented with 100-review threshold |
| Q7 age-rating matrix | `mart_age_rating_genre` | Implemented |
| Q9 language count | `mart_genre_language_benchmarks` | Implemented |
| Q10 keyword search | `mart_description_search` + dashboard variable | Implemented |
| Q11 top 3 by genre | `mart_top_games_by_genre` | Implemented with 100-review threshold |
| Q12 annual trend | `mart_release_yearly` | Implemented |
| Q13 consistency/stdev | `mart_developer_consistency` | Implemented with 3-game and 3-rated-game minimums |
| Q14 size buckets/correlation | `mart_size_rating_buckets` | Implemented as descriptive comparison |
| Q15 genre tag split/unnest | `mart_genre_tags` | Implemented |

All downstream gold and plat analytical models use `fct_games` as the driving
relation and join `dim_game` by `app_id` when descriptive attributes are needed.
This keeps metric ownership in the fact and descriptive ownership in the
dimension while preserving one row per game.

## 10. Delivery Plan

### Phase 1: Foundation

- Confirm Fivetran sync into `postgres.mobile_games.games`.
- Run source profiling for row count, null rates, duplicate `app_id`, date range,
  price range, and distinct genre/developer counts.
- Run `dbt build` and resolve data quality failures.

### Phase 2: Core reporting

- Publish Q1-Q5 as reusable marts and charts.
- Add a catalog KPI board with total games, average rating, and total review count.
- Add definitions and filters for genre, monetization type, release year, and age rating.

### Phase 3: Advanced analysis

- Review Q6/Q11 review threshold with stakeholders; the current value is 100.
- Review Q13 minimum developer portfolio size; the current values are 3 games and 3 rated games.
- Add a board or report per stakeholder workflow rather than one overcrowded board.

### Phase 4: Operationalization

- Schedule Fivetran sync and dbt build.
- Add CI checks for YAML, `dbt parse`, `dbt build`, and `dct validate charts/`.
- Record model freshness, row counts, test results, and board render status.

## 11. Definition of Done

The project is ready for stakeholder use when:

- Fivetran Test Connection and first sync succeed.
- `postgres.mobile_games.games` contains the expected source data.
- `dbt build` completes with zero errors and zero unexpected warnings.
- All required marts have documented grain, metrics, filters, and null policy.
- Each completed question has a reproducible query and acceptance result.
- `dct validate charts/` passes and the board renders from the Supabase profile.
- No credentials appear in Git-tracked files, logs, generated artifacts, or board YAML.

## 12. Source Notes

- Schema page: https://dataset.xomdata.com/datasets/schema/mobile_games
- Table page: https://dataset.xomdata.com/datasets/mobile_games.games
- The schema page describes the dataset as a market-research snapshot and
  explicitly notes that there is no transaction/revenue data.
