# Silver Layer (Staging & Cleansing)

The Silver layer transforms raw source data into standardized, clean, and typed relational records ready for dimensional modeling.

## Directory Contents

- [`stg_games.sql`](stg_games.sql): Staging transformation query for games catalog data.
- [`stg_games.yml`](stg_games.yml): Schema tests, documentation, and column contracts for `stg_games`.

## Cleansing Operations

The `stg_games` model applies the following transformations:

1. **Identifier Normalization**:
   - Casts raw `id` to integer `app_id`.
   - Renames `name` to `game_name`.
2. **Text Sanitization & Null Standardization**:
   - Uses `clean_text(description)` and `clean_text(languages)` macros to trim blank or whitespace-only strings to genuine SQL `NULL` values.
3. **Data Type Casting & Unit Conversions**:
   - Size converted from raw bytes to Megabytes (`size_bytes / 1024.0 / 1024.0`) rounded to 2 decimal places as `size_mb`.
   - Prices cast to `numeric(10, 2)` as `price_usd`.
   - `original_release_date` parsed as `DATE` (`release_date`), with derived `release_year`.
4. **Feature Derivation**:
   - `monetization_type`: Categorizes games into `'free'` (price = 0) vs `'paid'` (price > 0).
   - `has_in_app_purchases`: Boolean flag checking presence of in-app purchase options.
   - `language_count`: Uses `count_delimited_values(languages)` macro to extract count of supported languages.

## Materialization & Target Schema

- **Materialization**: `view` (ensures staging logic is lightweight and always reflects the latest raw state).
- **Target Schema**: `silver`
