-- ============================================================
-- UPROOT ARCADE — PIN upgrade (run once in the Supabase SQL Editor)
-- Adds 4-digit PINs with "reset = new life" semantics:
--   * accounts get generations (gen); a PIN reset inserts gen+1
--   * old generations keep their scores forever (ghosts 👻)
--   * weekly credits stay shared per email across generations
--   * PIN hashes are write-only for the public key; checks run
--     through a server-side function, so PINs can never be read
-- ============================================================

create extension if not exists pgcrypto with schema extensions;

alter table roster add column if not exists gen int not null default 1;
alter table roster add column if not exists pin_hash text;
alter table roster add column if not exists has_pin boolean
  generated always as (pin_hash is not null) stored;

-- move to (email, gen) identity
alter table scores drop constraint if exists scores_email_fkey;
alter table roster drop constraint if exists roster_pkey;
alter table roster add primary key (email, gen);
drop index if exists roster_name_unique;

alter table scores add column if not exists gen int not null default 1;
alter table scores add constraint scores_roster_fkey
  foreign key (email, gen) references roster(email, gen);

-- PIN hashes: never readable, settable exactly once while empty.
-- (Postgres: a table-level SELECT grant overrides column revokes,
--  so revoke the table grant and re-grant only the safe columns.)
revoke select on table roster from anon, authenticated;
grant select (email, name, gen, has_pin, joined_at) on table roster to anon, authenticated;
revoke update on table roster from anon, authenticated;
grant update (pin_hash) on table roster to anon, authenticated;
create policy roster_claim_pin on roster for update
  using (pin_hash is null) with check (pin_hash is not null);

-- online-only PIN verification (no hash ever leaves the database)
create or replace function check_pin(p_email text, p_gen int, p_pin text)
returns boolean language sql security definer stable
set search_path = public, extensions as $$
  select exists (
    select 1 from roster r
    where r.email = p_email and r.gen = p_gen
      and r.pin_hash = encode(extensions.digest(p_email || ':' || p_pin || ':uproot-arcade', 'sha256'), 'hex')
  );
$$;
grant execute on function check_pin(text, int, text) to anon, authenticated;
