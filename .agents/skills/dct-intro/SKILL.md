---
name: dct-intro
kind: workflow
surfaces:
- cli
description: >-
  Orientation for an agent meeting dbt charts for the first time: what the tool is,
  the shortest path from data to a rendered board, and which skill to read next. Use
  when asked to 'make charts of this with dbt charts', 'chart this on dbt charts',
  or 'use dbt charts', before any other skill. Do NOT use once you know the tool —
  go straight to dct-board-build.
metadata:
  author: fivetran
---
# dbt charts in five minutes

dbt charts turns a YAML file into a rendered board: a query (SQL against a
source, or rows written inline), charts that map the query's columns to visual
encodings, and a layout. `dct` is the open-source CLI that validates, renders,
and serves those files. dbtcharts.com (dbt charts Cloud) hosts the same files
from a git repository with a warehouse connection and sharing. It is not dbt
Labs' dbt Cloud (getdbt.com), and a local board needs no account.

You are reading this because someone asked for charts and you may not know the
tool yet. Read it once, then follow the skill it hands you to. The deliverable
is board YAML rendered by `dct` — not a plotting library, a notebook, or an
HTML canvas, however good those would look.

## 1. Check the install

```bash
dct --version || uv tool install dbt-charts   # or: pip install dbt-charts
```

## 2. Find the data, then the project

Every chart reads a query, and every query reads a source. Three cases:

- **Numbers already in hand** — a `type: values` query with the rows inline.
  Renders anywhere, no source at all.
- **A file** (CSV, JSON, Parquet) — either `source: ./data/orders.csv` inline
  on the query, resolved from the board's directory or the project root, or a
  named source in `dbt_charts.yml` (`type: csv`, a `files:` map of table name
  to path) that every board can query by name. No database needed.
- **A warehouse** — a `sources:` entry in `dbt_charts.yml`, or the dbt profile
  of the dbt project you are standing in (`dct` finds `dbt_project.yml` and
  reads `profiles.yml` itself). DuckDB and SQLite work locally but Cloud only
  connects to BigQuery, Postgres, Redshift, and Snowflake — if the boards will
  be published, say so before authoring against a local database.

Boards live in a project: a `dbt_charts.yml` beside a `charts/` directory. In
a dbt repo that is the repo root; `dct init --yes` scaffolds it, with a starter
board that renders without a database. Outside a repo, ask where the project
should live before scaffolding one, or, for a one-off, render straight from
stdin: `dct render - --format terminal` reads a whole board from a pipe.

## 3. The loop

Write `charts/<name>.yml`, then:

```bash
dct validate charts/            # structure and references, no warehouse call
dct render charts/<name>.yml    # SVG by default; --format png|html|terminal
dct serve                       # live preview, re-renders on every save
```

`dct serve` prints a URL; open it, hand it to the user, and leave the server
running while you iterate. A render that fails names a diagnostic code —
`dct docs errors <CODE>` explains it, and `dct-troubleshooting` is the skill
for anything that stays broken.

## 4. Learn the language as you go

- `dct docs` — the YAML field reference: `dct docs cheatsheet` first, then
  `dct docs <topic>` or `dct docs -s "<query>"`. Never guess a key.
- `dct examples` — complete boards with inline data; copy the one nearest to
  what you need and point its query at the real source.
- `dct skills` — the workflow skills below, and the layout patterns (a KPI
  row, top-N with detail, before/after) each with a copyable example.

## 5. Which skill next

| You are about to… | Read |
|---|---|
| Answer an analytical question ("show me…", "why did X change") | `dct-analyst-runbook` — triage, shape, verify, deliver |
| Look at an unfamiliar schema before writing anything | `dct-data-exploration` |
| Write or edit a board | `dct-board-build` — the build, validate, render loop |
| Choose chart types, layout, or color | `dct-board-design` |
| Write a narrative report rather than a dashboard | `dct-report-design` |
| Reproduce a dashboard from a screenshot or export | `dct-board-replicate` |
| Check the board before handing it over | `dct-board-review` (runs `dct-board-structural-review` and `dct-board-visual-review`) |
| Fix a render or query error | `dct-troubleshooting` |
| Publish to dbtcharts.com | `dct-cloud-setup` — sign in, connect the repo, map sources, render |
| Wire dbt charts into an MCP client instead of the shell | `dct-mcp-setup` |

For "make charts of this", the path is `dct-analyst-runbook` → `dct-board-build`,
then `dct-cloud-setup` only if the user wants the boards live.

## Installing the skills is optional

`dct skills <name>` prints any skill in full; nothing needs installing to read
one. `dct init skills` copies the workflow skills into a repository's
`.claude/skills/` or `.agents/skills/` so your harness finds them by
description on later turns without this detour. Do that only inside a repo the
user wants them committed to, naming the target when the repo has no
`CLAUDE.md` or `AGENTS.md` for it to detect (`dct init skills claude`,
`dct init skills agents`). To carry them across every project instead, install
once into your user-level directories: `dct init skills --global`.

## Done looks like

The user looking at the board: the `dct serve` URL, with the server still
running and you saying so, or the dbtcharts.com URL `dct cloud boards` reports
after `dct-cloud-setup`. Alongside it, one or two sentences on what the data says
and what you assumed about metric, grain, and time window.
