-- UPROOT ARCADE — Week 5 game row (run once before Sept 19)
insert into games (week, name, tries) values (5, 'Brand Blitz', 3)
on conflict (week) do update set name = excluded.name, tries = excluded.tries;
