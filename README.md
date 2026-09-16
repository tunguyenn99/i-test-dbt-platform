# Xom Arcade Analytics Platform

End-to-end ELT project for the Xom Arcade mobile game catalog:

1. Xom Dataset SQL Server is the OLTP source.
2. Fivetran replicates `mobile_games.games` into Supabase Postgres.
3. dbt Core cleans the raw table and builds analytical marts for genre,
	developer, and release-trend reporting.

## Prerequisites

- Python 3.10+
- `uv` for Python and CLI tooling
- A configured Fivetran connector and Supabase project

## Local setup

1. Create the environment and install dbt Core:

```sh
uv python install 3.12
uv venv --python 3.12 .venv
uv pip install --python .venv/bin/python dbt-postgres
uv tool install dbt-charts
```

2. Copy `.env.example` to `.env` and fill in the credentials. A local `.env`
	is already ignored by Git.
3. Run `scripts/supabase_fivetran_setup.sql` while connected to the existing
	Supabase `postgres` database. Do not create a separate destination database.
4. Configure Fivetran using `scripts/fivetran_source_setup.md`.
5. After the first Fivetran sync, run:

```sh
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dbt debug
DBT_PROFILES_DIR="$PWD" dbt build
```

## Visual walkthrough

### 1. Configure the source

The source is the Xom Dataset SQL Server database and the replicated table is
`mobile_games.games`.

![SQL Server source setup](images/source-sql-server-setup.png)

![Fivetran source sync options](images/source-sql-server-sync-option.png)

![Fivetran source sync result](images/source-sql-server-sync-result.png)

### 2. Configure the destination

Fivetran writes to the existing Supabase `postgres` database using the
`mobile_games` schema and the IPv4-compatible Session Pooler connection.

![Supabase destination schema](images/dest-postgres-schema.png)

![Supabase destination result](images/dest-postgres-result.png)

### 3. Explore dbt Charts

The project contains a full research board with Executive, Market and
Portfolio, Quality and Trends, and Search tabs.

![dbt Charts project directory](images/dct-directory.png)

![Research board executive view](images/dct-dashboard-demo-p1.png)

![Research board market view](images/dct-dashboard-demo-p2.png)

![Research board quality view](images/dct-dashboard-demo-p3.png)

![Research board search view](images/dct-dashboard-demo-p4.png)

### 4. Generate dbt Docs

Generate and serve the model catalog and lineage documentation with:

```sh
DBT_PROFILES_DIR="$PWD" dbt docs generate
DBT_PROFILES_DIR="$PWD" dbt docs serve --port 8080
```

![Generated dbt Docs](images/dbt-docs-generate.png)

## dbt Charts

`dct init --yes` initialized `dbt_charts.yml` and the `charts/` directory.
The main board is `charts/xom_arcade_overview.yml` and reads the dbt marts
through the `analytics` dbt profile source.

Validate and render the boards:

```sh
dct validate charts/
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dct render charts/xom_arcade_overview.yml --format terminal
dct serve
```

`dct serve` provides a local browser URL for the live board preview.

For Supabase connections from Fivetran or IPv4-only environments, use the
Session Pooler endpoint and the project-qualified username documented in
`scripts/fivetran_source_setup.md`. The Direct `db...supabase.co` endpoint can
fail at DNS or timeout when the client has no IPv6 connectivity.

Silver views are created in `analytics_silver`, gold dimensions/facts in
`analytics_gold`, and plat marts in `analytics_plat` by dbt's custom schema
naming convention.

## Models

- `models/bronze/`: Fivetran source contract only (`sources.yml`)
- `models/silver/`: typed and cleaned source records (`stg_games`)
- `models/gold/`: conformed dimensions, facts, and reusable intermediate
	analytics (`dim_game`, `fct_games`, `int_*`)
- `models/plat/`: stakeholder-facing marts (`mart_*`) consumed by dashboards

The layer schemas are `analytics_silver`, `analytics_gold`, and
`analytics_plat`. Bronze is metadata for the replicated `mobile_games` source,
so it does not create a warehouse relation.

Core models:

- `stg_games`: typed and cleaned source records in silver
- `dim_game`: one row per game containing descriptive attributes in gold
- `fct_games`: one row per game with release year and monetization type in gold
- `mart_genre_performance`: genre-level ratings, popularity, size, and pricing
- `mart_developer_benchmarks`: developer portfolio benchmarks
- `int_release_trends`: year-over-year release trends by genre
- `mart_monetization_mix`: free versus paid mix for Q1
- `mart_price_distribution`: price buckets for Q5
- `mart_games_2019`: 2019 releases by genre for Q4
- `mart_age_rating_genre`: age-rating by genre matrix for Q7
- `mart_genre_language_benchmarks`: localization breadth for Q9
- `mart_high_rated_games` and `mart_top_games_by_genre`: Q6/Q11 rankings
- `mart_developer_consistency`: portfolio quality for Q13
- `mart_size_rating_buckets`: size versus rating comparison for Q14
- `mart_genre_tags`: multi-valued genre tag ranking for Q15
- `mart_description_search`: parameter-ready description search for Q10
- `mart_release_yearly`: annual release trend for Q12
