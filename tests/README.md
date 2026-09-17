# Data Quality & Automated Tests

This directory contains automated dbt test suites designed to safeguard data integrity, grain uniqueness, metric non-negativity, and reconciliation across all layers of the Xom Arcade Analytics Platform.

## Test Types

### 1. Schema / Generic Tests
Configured directly inside YAML files (`sources.yml`, `stg_games.yml`, `gold.yml`, `plat.yml`):
- `unique` & `not_null`: Assert primary keys (e.g. `app_id`) have no duplicates or missing values.
- `accepted_values`: Ensure domain categories (e.g. `monetization_type IN ('free', 'paid')`) remain valid.
- `relationships`: Ensure referential integrity between fact and dimension keys.

### 2. Custom Singular Tests (SQL Assertions)

Custom SQL assertions execute query logic where any returned row indicates a test failure:

| Test File | Target Model | Validation Purpose |
| :--- | :--- | :--- |
| [`assert_fct_games_one_row_per_app.sql`](assert_fct_games_one_row_per_app.sql) | `fct_games` | Asserts that every application appears exactly once in the core fact table (grain integrity). |
| [`assert_fct_games_metrics_non_negative.sql`](assert_fct_games_metrics_non_negative.sql) | `fct_games` | Validates that ratings, counts, size, and price metrics never drop below zero. |
| [`assert_dim_game_language_count_non_negative.sql`](assert_dim_game_language_count_non_negative.sql) | `dim_game` | Ensures parsed language count is never negative. |
| [`assert_genre_tags_are_non_empty.sql`](assert_genre_tags_are_non_empty.sql) | `mart_genre_tags` | Confirms extracted genre tag strings are non-blank. |
| [`assert_monetization_mix_reconciles.sql`](assert_monetization_mix_reconciles.sql) | `mart_monetization_mix` | Confirms sum of free and paid games in the mart reconciles exactly to total count in `fct_games`. |
| [`assert_price_distribution_reconciles.sql`](assert_price_distribution_reconciles.sql) | `mart_price_distribution` | Confirms sum of price tier buckets reconciles exactly with total paid games. |
| [`assert_release_yearly_reconciles.sql`](assert_release_yearly_reconciles.sql) | `mart_release_yearly` | Confirms sum of annual releases reconciles with all dated games in `fct_games`. |
| [`assert_size_rating_buckets_reconciles.sql`](assert_size_rating_buckets_reconciles.sql) | `mart_size_rating_buckets` | Confirms sum of small, medium, and large size buckets reconciles to the catalog total. |

## Running Tests

```sh
# Run all project tests
dbt test

# Run singular tests only
dbt test --select "test_type:singular"

# Run tests on a specific layer or model
dbt test --select models/gold
dbt test --select fct_games
```
