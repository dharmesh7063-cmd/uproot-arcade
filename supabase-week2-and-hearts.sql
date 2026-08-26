-- ============================================================
-- UPROOT ARCADE — one paste, two jobs (safe to run more than once)
-- 1) Registers Week 2 (Stain Sniper, 3 credits) so the credit cap
--    is enforced server-side when it auto-launches Monday.
-- 2) Creates the Hall of Fame hearts table (one ❤️ per player per
--    legend, insert-only, no comments).
-- ============================================================

insert into games (week, name, tries) values (2, 'Stain Sniper', 3)
on conflict (week) do update set name = excluded.name, tries = excluded.tries;

create table if not exists reactions (
  id bigint generated always as identity primary key,
  target text not null check (char_length(target) between 1 and 40),
  email text not null,
  emoji text not null default '❤️' check (char_length(emoji) <= 8),
  created_at timestamptz not null default now(),
  unique (target, email)
);

alter table reactions enable row level security;
drop policy if exists reactions_read on reactions;
drop policy if exists reactions_insert on reactions;
create policy reactions_read on reactions for select using (true);
create policy reactions_insert on reactions for insert
  with check (exists (select 1 from roster r where r.email = reactions.email));
-- no update/delete policies: hearts can never be taken back
