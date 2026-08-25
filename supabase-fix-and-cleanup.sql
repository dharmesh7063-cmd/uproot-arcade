-- ============================================================
-- UPROOT ARCADE — one-time fix + test-data purge
-- 1) Makes PIN hashes truly write-only (the earlier column revoke
--    was overridden by the table-level SELECT grant).
-- 2) Removes the test accounts used to verify the system.
-- ============================================================

revoke select on table roster from anon, authenticated;
grant select (email, name, gen, has_pin, joined_at) on table roster to anon, authenticated;

delete from scores where email in ('test.bot@uprootclean.com', 'qa.pin@uprootclean.com');
delete from roster  where email in ('test.bot@uprootclean.com', 'qa.pin@uprootclean.com');
