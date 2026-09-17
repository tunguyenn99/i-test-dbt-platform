# dbt Charts (Interactive BI Dashboards)

This directory houses the declarative dashboard definitions built using **dbt Charts**, delivering interactive data exploration and stakeholder reporting directly on top of the Supabase PostgreSQL data warehouse and dbt data marts.

## Directory Structure

```text
charts/
├── guide.yml                   # Stakeholder navigation guide and analytical dictionary
├── meta.yml                    # Workspace metadata, project tags, and author info
├── partials/                   # Reusable visual components and chart templates
│   └── .gitkeep
├── xom_arcade_overview.yml     # Executive summary dashboard
└── xom_arcade_research.yml     # Comprehensive 4-tab research board answering Q1–Q15
```

## Dashboard Specifications

### 1. Executive Overview (`xom_arcade_overview.yml`)
Designed for leadership and general stakeholders for fast, at-a-glance health metrics:
- **Catalog KPIs**: Total titles, average user rating, cumulative review counts.
- **Genre Performance**: Top categories ranked by player engagement (reviews) and pricing.
- **Release Trends**: Historic release volumes and peak release periods.
- **Top Developers**: Developer leaderboards by portfolio size and ratings.

### 2. Full Market Research Board (`xom_arcade_research.yml`)
Directly addresses the 15 core business questions specified in [`BUSINESS REQUIREMENTS.md`](../BUSINESS%20REQUIREMENTS.md), organized into 4 logical tabs:

1. **Executive Tab**:
   - High-level KPIs and catalog health metrics.
   - **Q1**: Free vs. Paid distribution, average ratings, and review volume comparisons.
   - **Q5**: Paid pricing tiers ($0.99, $1.99, $2.99, $4.99+) and revenue proxy shares.
2. **Market and Portfolio Tab**:
   - **Q4**: 2019 peak release volume breakdown by primary genre.
   - **Q7**: Age rating distribution matrix (`4+`, `9+`, `12+`, `17+`) across genres.
   - **Q9**: Localization support and average language count benchmarks.
   - **Q13**: Developer rating consistency analysis (identifying reliable studios).
3. **Quality and Trends Tab**:
   - **Q6**: High-rated games ($\ge 4.5$) with verified review scale ($\ge 100$ ratings).
   - **Q11**: Top 3 rated games per genre.
   - **Q12**: Annual release trends and year-over-year (YoY) growth.
   - **Q14**: Application file size vs. user rating correlation analysis.
   - **Q15**: Frequency distribution of multi-valued genre tag combinations.
4. **Search and Discovery Tab**:
   - **Q10**: Interactive parameter search allowing stakeholders to filter and rank game titles by typing dynamic keywords (e.g. `:keyword` variable default: `puzzle`).

## Root Configuration (`dbt_charts.yml`)

The platform-level configuration lives in [`dbt_charts.yml`](../dbt_charts.yml) at the project root, connecting to the Supabase data warehouse via environment credentials:
- **Connection Profile**: `analytics` (pointing to `POSTGRES_HOST`, `POSTGRES_DB`, etc.).
- **Theme**: Clean modern dark/light styling with custom color palettes.

## How to Run & Preview Dashboards

Ensure environment variables are loaded from `.env`:

```sh
# Load credentials
set -a
. ./.env
set +a

# Launch local dbt Charts development server
dbt-charts dev

# Validate all dashboard queries against the warehouse
dbt-charts check
```
Dashboards will be available at `http://localhost:3000` (or specified local port).
