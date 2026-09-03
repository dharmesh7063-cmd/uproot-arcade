-- ============================================================
-- UPROOT ARCADE — weeks now run TUESDAY → MONDAY (anchor Tue 2026-08-25)
-- Run once in the SQL Editor BEFORE Friday Sept 4 (Eastern).
-- Re-anchors the time-lock: runs accepted only for the current
-- Tue→Mon week, never on ceremony Monday. Credit caps unchanged.
-- ============================================================
drop policy if exists scores_insert on scores;
create policy scores_insert on scores for insert
  with check (
    week = ((((now() at time zone 'America/New_York')::date) - date '2026-08-25') / 7 + 1)
    and ((((now() at time zone 'America/New_York')::date) - date '2026-08-25') % 7) <> 6
    and attempt <= (select g.tries from games g where g.week = scores.week)
                   + coalesce((select b.extra from credit_bonuses b
                                 where b.email = scores.email and b.week = scores.week), 0)
    and (select count(*) from scores s
           where s.email = scores.email and s.week = scores.week)
        < (select g.tries from games g where g.week = scores.week)
          + coalesce((select b.extra from credit_bonuses b
                        where b.email = scores.email and b.week = scores.week), 0)
  );
