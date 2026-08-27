-- ============================================================
-- UPROOT ARCADE — bug bounty system (run once in the SQL Editor)
-- 1) credit_bonuses: extra credits granted to specific players
--    for a specific week. Readable by all, grantable ONLY from
--    this dashboard (no insert policy for the public key).
-- 2) Awards Dini +1 Week-2 credit for finding the week-gate gap.
-- 3) Rebuilds the score-insert rules to honor bonuses on top of
--    the clamp + Eastern-week time-lock.
-- ============================================================

create table if not exists credit_bonuses (
  email text not null,
  week int not null,
  extra int not null default 1 check (extra between 1 and 5),
  reason text,
  created_at timestamptz not null default now(),
  primary key (email, week)
);
alter table credit_bonuses enable row level security;
drop policy if exists bonuses_read on credit_bonuses;
create policy bonuses_read on credit_bonuses for select using (true);
-- deliberately NO insert/update/delete policies: bounties are dashboard-only

insert into credit_bonuses (email, week, extra, reason)
values ('thiago@uprootclean.com', 2, 1, 'Bug bounty: found the week-gate gap (DiniLeak, Aug 2026)')
on conflict (email, week) do update set extra = excluded.extra, reason = excluded.reason;

drop policy if exists scores_insert on scores;
create policy scores_insert on scores for insert
  with check (
    week = ((((now() at time zone 'America/New_York')::date) - date '2026-08-22') / 7 + 1)
    and ((((now() at time zone 'America/New_York')::date) - date '2026-08-22') % 7) <> 6
    and attempt <= (select g.tries from games g where g.week = scores.week)
                   + coalesce((select b.extra from credit_bonuses b
                                 where b.email = scores.email and b.week = scores.week), 0)
    and (select count(*) from scores s
           where s.email = scores.email and s.week = scores.week)
        < (select g.tries from games g where g.week = scores.week)
          + coalesce((select b.extra from credit_bonuses b
                        where b.email = scores.email and b.week = scores.week), 0)
  );
