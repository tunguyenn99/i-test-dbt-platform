-- Run this while connected to the existing Supabase `postgres` database.
-- The Fivetran result is expected at postgres.mobile_games.games.

do $$
begin
	if not exists (select from pg_roles where rolname = 'fivetran') then
		create role fivetran login password 'fivetran';
	end if;
end
$$;

grant connect on database postgres to fivetran;
grant create, temporary on database postgres to fivetran;

create schema if not exists mobile_games;
grant usage, create on schema mobile_games to fivetran;

-- Required only when the table already exists and was created by another role.
grant select, insert, update, delete, truncate, references, trigger
on all tables in schema mobile_games to fivetran;

alter default privileges in schema mobile_games
grant select, insert, update, delete, truncate, references, trigger
on tables to fivetran;
