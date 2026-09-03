-- ⚠️ SUPERSEDED (2026-09-03): the scores_insert policy below uses the OLD Saturday anchor (2026-08-22).
-- Weeks now run Tuesday→Monday — the current policy lives in supabase-tuesday-weeks.sql. Do NOT re-run this file.

-- ============================================================
-- UPROOT ARCADE — the brick wall (run once in the SQL Editor)
-- 1) Scores above 2500 are rejected by the database itself.
--    (NOT VALID = existing rows like the famous 9999 stay put.)
-- 2) Runs are only accepted for the CURRENT Eastern week, and
--    never on ceremony Fridays — client clock-spoofing is useless.
-- ============================================================

alter table scores add constraint scores_plausible
  check (score between 0 and 2500) not valid;

drop policy if exists scores_insert on scores;
create policy scores_insert on scores for insert
  with check (
    week = ((((now() at time zone 'America/New_York')::date) - date '2026-08-22') / 7 + 1)
    and ((((now() at time zone 'America/New_York')::date) - date '2026-08-22') % 7) <> 6
    and attempt <= (select g.tries from games g where g.week = scores.week)
    and (select count(*) from scores s
           where s.email = scores.email and s.week = scores.week)
        < (select g.tries from games g where g.week = scores.week)
  );
