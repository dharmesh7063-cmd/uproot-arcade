-- ============================================================
-- UPROOT ARCADE — SEASON FINALE bundle (run once in the SQL Editor)
-- 1) Nico's bug bounty: +1 Week 5 credit
-- 2) Week 5 game renamed: Brand Blitz → Shed Rush
-- 3) Score wall raised to 6000 (Shed Rush ceiling ~4500)
-- ============================================================
insert into credit_bonuses (email, week, extra, reason) values
  ('nicolas@uprootclean.com', 5, 1, 'Bug bounty: found the PIN-reset takeover gap and the bonus-credit retry bug (Sept 2026)')
on conflict (email, week) do update set extra = excluded.extra, reason = excluded.reason;

update games set name = 'Shed Rush' where week = 5;

alter table scores drop constraint scores_plausible;
alter table scores add constraint scores_plausible check (score between 0 and 6000) not valid;
