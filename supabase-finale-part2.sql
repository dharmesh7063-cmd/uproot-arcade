update games set name = 'Shed Rush' where week = 5;
alter table scores drop constraint scores_plausible;
alter table scores add constraint scores_plausible check (score between 0 and 8000) not valid;
