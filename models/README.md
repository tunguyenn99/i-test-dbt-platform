# dbt Model Layers (Medallion Architecture)

This directory contains the layered dbt data transformations for the Xom Arcade Analytics Platform, following the **Medallion Architecture** pattern to guarantee clean data lineage, contract validation, and query performance.

## Architecture Overview

```text
               +-------------------------------------------------------+
               |                  Supabase PostgreSQL                 |
               |                 (mobile_games.games)                  |
               +-------------------------------------------------------+
                                          |
                                          v
+-----------------------------------------------------------------------------------------+
|                                    dbt Core Pipeline                                     |
|                                                                                         |
|  [ Bronze Layer ]     -->   [ Silver Layer ]    -->  [ Gold Layer ]   --> [ Plat Layer ] |
|  Raw Source Contracts       Staging & Cleansing      Star Schema           Business Marts|
|  sources.yml                stg_games.sql            dim_game.sql          14x mart_*.sql|
|                                                      fct_games.sql                       |
|                                                      int_release_trends                  |
+-----------------------------------------------------------------------------------------+
                                          |
                        +-----------------+-----------------+
                        |                                   |
                        v                                   v
             [ dbt Charts Dashboards ]              [ dbt Docs Catalog ]
```

## Layers Breakdown

| Layer | Directory | Description | Materialization | Schema |
| :--- | :--- | :--- | :--- | :--- |
| **Bronze** | [`bronze/`](bronze/README.md) | Source table declarations, schema definitions, and ingest contracts. | N/A (External source) | `mobile_games` |
| **Silver** | [`silver/`](silver/README.md) | Staging model: type casting, null-handling, text cleaning, feature derivation. | `view` | `silver` |
| **Gold** | [`gold/`](gold/README.md) | Core dimensional star schema: decoupled entity dimensions and numerical facts. | `table` | `gold` |
| **Platinum** | [`plat/`](plat/README.md) | Analytical marts pre-aggregated to answer business questions Q1–Q15. | `table` | `plat` |

## Design Principles

1. **Explicit Lineage**: Downstream models only reference models from their immediate precursor or parent layer.
2. **Strict Grain**: Every model explicitly defines and tests its primary key grain (e.g., `app_id` uniqueness).
3. **DRY Macros**: Text cleansing, safe division, and delimited parsing are centralized in [`macros/`](../macros/README.md).
4. **Performance Optimized**: Heavy analytical marts in the Platinum layer are materialized as `table` to provide instantaneous query speeds for dbt Charts.

## Common CLI Commands

```sh
# Parse and validate the entire project model DAG
dbt parse

# Build and test all models across all layers
dbt build

# Build a specific layer
dbt build --select models/bronze
dbt build --select models/silver
dbt build --select models/gold
dbt build --select models/plat
```
