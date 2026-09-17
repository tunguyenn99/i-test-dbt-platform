# Bronze Layer (Raw Source Contracts)

The Bronze layer defines the contract and schema declarations for the raw data replicated from the source Microsoft SQL Server into Supabase PostgreSQL.

## Directory Contents

- [`sources.yml`](sources.yml): dbt source configuration defining the landing tables under the `mobile_games` schema.

## Source Specification

- **Source Name**: `mobile_games`
- **Underlying Database**: `postgres`
- **Replication Tool**: Fivetran (automated CDC / scheduled sync)
- **Tables**:
  - `games`: Raw mobile game records with original column names and raw data types.

## Column Schema & Contracts

The `sources.yml` contract validates:
- **`id`**: Unique primary key constraint from the source.
- **`name`**: Game title string.
- **`price`**: Raw price value.
- **`size_bytes`**: Raw size in bytes.
- **`primary_genre`**: Primary categorization.
- **`languages`**: Raw comma-delimited language list.
- **`original_release_date`**: ISO release date string.

## Rules & Constraints

1. **Zero Transformation**: No SQL files or data mutations are permitted in the Bronze layer.
2. **Contract Validation**: Acts as a defensive perimeter ensuring Fivetran's sync matches expected data types and column presence before downstream models run.
