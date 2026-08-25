-- ============================================================
-- UPROOT ARCADE — database schema (paste into Supabase SQL Editor and Run)
-- Scores are stored here permanently, for this and every future game,
-- readable by everyone. The public (anon) key can only READ everything
-- and INSERT within the rules below — it can never edit or delete history.
-- ============================================================

-- One row per weekly game; `tries` = credits per player that week.
create table if not exists games (
  week int primary key,
  name text not null,
  tries int not null default 3 check (tries between 1 and 10),
  created_at timestamptz not null default now()
);

-- The permanent team roster: one account per @uprootclean.com email.
create table if not exists roster (
  email text primary key
    check (email = lower(email) and email like '%@uprootclean.com'),
  name text not null check (char_length(name) between 2 and 20),
  joined_at timestamptz not null default now()
);
create unique index if not exists roster_name_unique on roster (lower(name));

-- Every official run ever played, across all weeks.
create table if not exists scores (
  id bigint generated always as identity primary key,
  email text not null references roster(email),
  week int not null references games(week),
  attempt int not null check (attempt between 1 and 10),
  score int not null check (score >= 0 and score <= 100000),
  streak int not null default 0 check (streak >= 0 and streak <= 10000),
  created_at timestamptz not null default now(),
  unique (email, week, attempt)
);

alter table games enable row level security;
alter table roster enable row level security;
alter table scores enable row level security;

-- Everyone can view everything (the public scoreboard).
create policy games_read  on games  for select using (true);
create policy roster_read on roster for select using (true);
create policy scores_read on scores for select using (true);

-- Anyone can sign up once; uniqueness of email + name is enforced above.
create policy roster_insert on roster for insert
  with check (email like '%@uprootclean.com');

-- Runs can only be added for a real game week, within its credit limit.
create policy scores_insert on scores for insert
  with check (
    attempt <= (select g.tries from games g where g.week = scores.week)
    and (select count(*) from scores s
           where s.email = scores.email and s.week = scores.week)
        < (select g.tries from games g where g.week = scores.week)
  );

-- No UPDATE or DELETE policies exist on purpose:
-- the public key can never change or wipe the history.

-- Week 1 config (each new week, add/adjust a row like this):
insert into games (week, name, tries) values (1, 'Fur Frenzy', 3)
on conflict (week) do update set name = excluded.name, tries = excluded.tries;
