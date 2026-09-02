-- ============================================================
-- UPROOT ARCADE — OVERTIME WEEK GIFT (run once in SQL Editor)
-- +1 W2 credit for EVERY player. Anyone who already holds a W2
-- bonus (Jared, Greg, Dini) is skipped automatically.
-- Also cleans the garbled dash in the two decree rows.
-- ============================================================

insert into credit_bonuses (email, week, extra, reason)
select distinct r.email, 2, 1, 'Overtime week hype - the Committee is feeling generous'
from roster r
on conflict (email, week) do nothing;

update credit_bonuses
set reason = 'Overtime decree: perfect 1360 tie - rematch coin for the Gauntlet'
where week = 2 and email in ('jared@uprootclean.com','gregory@uprootclean.com');
