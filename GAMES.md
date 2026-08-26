# 🕹️ Uproot Arcade — Game Pipeline

This branch (`games-lab`) is the workshop: the idea backlog, up to **5 games in development at a time**, and launch notes. Launched games live on `main` (one folder per week) and stay there forever.

## Season rules (v2, set 2026-08-26)
- A season = **5 weeks**. Champion = highest total of weekly bests (cheat-flagged scores excluded).
- Hall of Fame on the site keeps the **last 6 season champions**.
- Cheat-smell detector: each game sets a plausibility ceiling (`SUS_LIMITS` in the page). Scores above it stay visible but get a public roast 🤖 and don't count for medals, weekly wins, or the championship.

## 🚀 Launched
| Week | Game | Credits | Sus limit | Notes |
|---|---|---|---|---|
| W1 | Fur Frenzy | 3 | 2000 | Tap fur, dodge socks, streak bonuses. 23 players day one. |

## 🛠️ Now developing (max 5)
Genre rule: every week a DIFFERENT genre · minimal · runs 1–2 min max.
1. **W2 — Lint Line** ✅ BUILT (memory/pattern) — Simon-style: repeat the growing lint pattern, +10 × round, beat round 16 to beat the machine. `week-02-lint-line/` on main, gated until Mon Sep 1. Sus limit 1500.
2. **W3 — Suds Stack** (timing/stacking) — falling soap bars, one tap to drop, stack them straight; height + neatness = score. Build by Sep 7.
3. **W4 — Mop Hop** (runner/dodge) — one-button mop hops buckets and cats for ~60s; near-misses give style points. Build by Sep 14.
4. **W5 — UPROOT BRAND BLITZ** (quiz) — SEASON 1 FINALE per Dharmesh: 8 random questions from a ~15-question pool, 10s each, 50 + 5×seconds-left per correct (max ≈800, sus 850). Draft pool exists (from uprootclean.com); NEEDS Dharmesh's fact-check + 3–5 insider questions before Sep 21.
5. *(open slot — Season 2 opener candidate)*

## 💡 Backlog
- Fur-nado Dodge (survive the swirling fur tornado)
- Sock Sort (match sock pairs against the clock)
- Squeegee Sprint (swipe to clear fog off a window, don't lift)
- Vacuum Maze (steer a robot vac through a room, battery draining)
- Grime Time II (Fur Frenzy remix, faster + boss stain)
- Stain Sniper (precision tap — parked: too close to Fur Frenzy's genre for back-to-back weeks)
- Package Panic (catch falling Uproot orders, don't drop any)

## 🧑‍🤝‍🧑 Team mode (future — design notes)
Goal: team vs team weeks, balanced and fair even when only ~20 of 28 play.
- Teams stored in a `teams` table + `team` column on roster (assigned, not chosen order — anyone can join any team *slot*, but balance rules apply).
- Balancing: snake-draft by season total (1st→A, 2nd→B, 3rd→B, 4th→A…) keeps skill even; re-draft each season.
- Uneven participation fix: team score = **average of each team's top K bests** (K = min players who played on either team), so a no-show never sinks a team and ringers can't stack one side.
- Alternative: median-of-bests. Decide when we build it.

## ✅ Weekly launch checklist
1. Copy the newest game folder from this branch to `main` as `week-NN-<name>/index.html`.
2. In the page constants: bump `WEEK`, `GAME_NAME`, `TRIES` fallback, add the week's `SUS_LIMITS` entry, update the week chip + "THIS WEEK" sub-label.
3. Insert the week's row in Supabase (SQL Editor): `insert into games (week, name, tries) values (NN, 'Name', T);`
4. `cp week-NN-<name>/index.html index.html` → commit → push (Pages deploys in ~1 min, CDN cache up to 10).
5. Post the new-week hype message in #random.
