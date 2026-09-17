# Gold Layer (Core Star Schema)

The Gold layer establishes the foundational dimensional star-schema for the analytics platform, separating descriptive entity attributes from measurable quantitative facts.

## Directory Contents

- [`dim_game.sql`](dim_game.sql): Entity dimension containing game metadata and categorizations.
- [`fct_games.sql`](fct_games.sql): Performance fact table containing quantitative measures and metrics.
- [`int_release_trends.sql`](int_release_trends.sql): Intermediate model tracking year-over-year release trends by genre.
- [`gold.yml`](gold.yml): Tests and documentation for dimensions, facts, and intermediate models.

## Model Specifications

### 1. `dim_game` (Dimension)
- **Grain**: One row per distinct `app_id`.
- **Primary Attributes**:
  - `app_id`: Natural unique application identifier.
  - `game_name`: Normalized title.
  - `developer`: Publishing entity.
  - `primary_genre`: Primary store classification.
  - `genres`: Multi-valued genre categories list.
  - `age_rating`: Content classification rating (`4+`, `9+`, `12+`, `17+`).
  - `description`: Text overview and marketing copy.
  - `languages`: Raw string of supported languages.
  - `language_count`: Integer count of supported languages.

### 2. `fct_games` (Fact Table)
- **Grain**: One row per distinct `app_id`.
- **Measures & Numeric Dimensions**:
  - `average_user_rating`: Average user rating (1.0 to 5.0).
  - `user_rating_count`: Total volume of user reviews.
  - `price_usd`: Retail price in USD.
  - `size_mb`: Application footprint in Megabytes.
  - `release_date`: Launch calendar date.
  - `release_year`: Launch year.
  - `monetization_type`: Categorical breakdown (`free` vs `paid`).
  - `has_in_app_purchases`: Boolean flag for microtransactions.

### 3. `int_release_trends` (Intermediate Model)
- Pre-computes annual game counts, average ratings, and popularity across genres to power historical trend analysis.

## Materialization & Target Schema

- **Materialization**: `table`
- **Target Schema**: `gold`
