# Provisioning & Setup Scripts

This directory contains database provisioning scripts and operational setup guides for integrating external data sources and pipeline tools into the Xom Arcade Analytics Platform.

## Directory Contents

| File | Type | Description |
| :--- | :--- | :--- |
| [`supabase_fivetran_setup.sql`](supabase_fivetran_setup.sql) | SQL Script | DDL script to configure user roles, schemas, and permissions for Fivetran in Supabase PostgreSQL. |
| [`fivetran_source_setup.md`](fivetran_source_setup.md) | Guide / Runbook | End-to-end instructions for configuring Fivetran source (SQL Server) and destination (Supabase). |

## Setup Workflow

1. **Supabase Destination Preparation**:
   - Connect to the default `postgres` database in Supabase using `psql` or the Supabase SQL Editor.
   - Execute [`supabase_fivetran_setup.sql`](supabase_fivetran_setup.sql) to create the dedicated `fivetran` user role, provision the `mobile_games` schema, and grant table creation and synchronization privileges.
2. **Fivetran Connector Setup**:
   - Follow [`fivetran_source_setup.md`](fivetran_source_setup.md) to register the Microsoft SQL Server source host, port, credentials, and select the `mobile_games.games` table.
   - Configure the destination connection using the Supabase IPv4 Session Pooler endpoint.
   - Trigger the initial sync to populate `postgres.mobile_games.games`.
