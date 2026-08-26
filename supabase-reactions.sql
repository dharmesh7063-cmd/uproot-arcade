-- ============================================================
-- UPROOT ARCADE — Hall of Fame hearts (run once in the SQL Editor)
-- One ❤️ per player per legend. No comments, no unlikes, hearts are forever.
-- ============================================================

create table if not exists reactions (
  id bigint generated always as identity primary key,
  target text not null check (char_length(target) between 1 and 40),
  email text not null,
  emoji text not null default '❤️' check (char_length(emoji) <= 8),
  created_at timestamptz not null default now(),
  unique (target, email)
);

alter table reactions enable row level security;
create policy reactions_read on reactions for select using (true);
create policy reactions_insert on reactions for insert
  with check (exists (select 1 from roster r where r.email = reactions.email));
-- no update/delete policies: hearts can never be taken back
