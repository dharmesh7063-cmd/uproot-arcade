-- ============================================================
-- UPROOT ARCADE — OVERTIME (run once in the SQL Editor)
-- 1) Rematch coins for the perfect-1360 tie (Jared & Greg).
-- 2) Raise the score clamp: Lint Line's new perfect is 3250.
-- ============================================================

insert into credit_bonuses (email, week, extra, reason) values
  ('jared@uprootclean.com',   2, 1, 'Overtime decree: perfect 1360 tie — rematch coin for the Gauntlet'),
  ('gregory@uprootclean.com', 2, 1, 'Overtime decree: perfect 1360 tie — rematch coin for the Gauntlet')
on conflict (email, week) do update set extra = excluded.extra, reason = excluded.reason;

alter table scores drop constraint scores_plausible;
alter table scores add constraint scores_plausible check (score between 0 and 3500) not valid;
