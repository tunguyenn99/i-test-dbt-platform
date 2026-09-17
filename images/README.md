# Visual Assets & Architecture Gallery

This directory stores visual assets, architecture schematics, and verification screenshots documenting each phase of the Xom Arcade Analytics Platform lifecycle.

## Assets Catalog

### Architecture Diagrams
- [`project-architecture.svg`](project-architecture.svg): Scalable vector diagram illustrating the complete Modern Data Stack pipeline from SQL Server through Fivetran, Supabase, dbt Core Medallion layers, to dbt Charts and dbt Docs, complete with official tool vector logos.

### 1. Ingestion Setup & Sync (Microsoft SQL Server Source)
- [`source-sql-server-setup.png`](source-sql-server-setup.png): Connection credentials, host configuration, and network validation for the SQL Server database.
- [`source-sql-server-sync-option.png`](source-sql-server-sync-option.png): Table-level synchronization selection focusing on `mobile_games.games`.
- [`source-sql-server-sync-result.png`](source-sql-server-sync-result.png): Successful initial ingestion run and record count confirmation in Fivetran.

### 2. Cloud Warehouse Landing (Supabase Destination)
- [`dest-postgres-schema.png`](dest-postgres-schema.png): Database schema inspection confirming the `mobile_games` schema in Supabase.
- [`dest-postgres-result.png`](dest-postgres-result.png): Query result verification of raw records ingested into `postgres.mobile_games.games`.

### 3. Analytics & BI Dashboards (dbt Charts)
- [`dct-directory.png`](dct-directory.png): Directory organization and project layout for dbt Charts YAML definitions.
- [`dct-dashboard-demo-p1.png`](dct-dashboard-demo-p1.png): **Executive Tab**: High-level KPIs, free vs paid mix, and monetization metrics (Q1, Q5).
- [`dct-dashboard-demo-p2.png`](dct-dashboard-demo-p2.png): **Market and Portfolio Tab**: 2019 releases, age rating breakdown, developer consistency, and language benchmarks (Q4, Q7, Q9, Q13).
- [`dct-dashboard-demo-p3.png`](dct-dashboard-demo-p3.png): **Quality and Trends Tab**: High-rated games, top titles by genre, file size vs rating, YoY trends, and genre tags (Q6, Q11, Q12, Q14, Q15).
- [`dct-dashboard-demo-p4.png`](dct-dashboard-demo-p4.png): **Search and Discovery Tab**: Dynamic keyword filter interface on game descriptions (Q10).

### 4. Lineage & Documentation (dbt Docs)
- [`dbt-docs-generate.png`](dbt-docs-generate.png): CLI compilation output and lineage DAG generation confirmation.
