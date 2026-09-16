# Fivetran Source Setup

## 1. Configure the SQL Server source

Create a SQL Server source using the Xom Dataset account:

- Host: `45.124.94.158`
- Port: `1433`
- Database: `xomdata_dataset`
- Schema: `mobile_games`
- Table: `games`

Use the source credentials from the local `.env` file. In Fivetran, select the
Supabase Postgres destination and replicate the source into the `mobile_games`
schema. The dbt source declaration expects the replicated table at
`postgres.mobile_games.games`.

The destination database is the existing Supabase database `postgres`; do not
create or select a separate destination database.

## 2. Configure the Supabase destination

Use the Supabase **Session Connection Pooler** instead of the Direct connection:

| Setting | Value |
| --- | --- |
| Host | `aws-0-ap-southeast-2.pooler.supabase.com` |
| Port | `6543` |
| Database | `postgres` |
| User for `postgres` | `postgres.kttubuuzrfmzuzfepzjo` |
| User for `fivetran` | `fivetran.kttubuuzrfmzuzfepzjo` |
| SSL | Require / verify-ca according to the Fivetran form |

The suffix after the dot is the Supabase project reference. Pooler usernames
must include it; `postgres` or `fivetran` alone is not enough. Use the
corresponding password for the selected user.

The Direct host (`db.kttubuuzrfmzuzfepzjo.supabase.co`) may resolve to IPv6.
Fivetran or an IDE without IPv6 support can time out before authentication, so
the Pooler endpoint is the compatible IPv4 route.

## Troubleshooting

- `FATAL: (ENOIDENTIFIER) no tenant identifier provided`: the username is
	missing the project reference. Use `fivetran.kttubuuzrfmzuzfepzjo` for the
	Fivetran role or `postgres.kttubuuzrfmzuzfepzjo` for the admin role.
- `timeout`, `could not translate host name`, or connection hangs: confirm
	host `aws-0-ap-southeast-2.pooler.supabase.com`, port `6543`, and that the
	client has outbound IPv4 access. Do not use the Direct host for this test.
- `password authentication failed`: verify the password belongs to the
	username being used. The `fivetran` role password is separate from the
	Supabase `postgres` password.
- `no pg_hba.conf entry` or rejected client IP: inspect Supabase Network
	Restrictions and allow the Fivetran connector's egress IP. Keep the project
	open to `0.0.0.0/0` only when that is an intentional project policy.
- `database does not exist`: Supabase normally provides the `postgres`
	database. Select it unless a separately provisioned custom database really
	exists.

After changing destination settings, run Fivetran's **Test connection** again
before starting the historical sync.

After the connector has completed its first sync, run dbt from the repository
root:

```sh
set -a
. ./.env
set +a
DBT_PROFILES_DIR="$PWD" dbt debug
DBT_PROFILES_DIR="$PWD" dbt build
```
