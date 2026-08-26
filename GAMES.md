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
1. **W2 — Uproot Brand Blitz (trivia)** — 10 rapid-fire questions about Uproot products/brand, 8s each; score = speed × correct. Dharmesh promised Jackie trivia! Needs a question list from the team.
2. **W3 — Stain Sniper** — stains flash on a rug grid for a blink; tap dead-center for bullseye bonus. Precision under time pressure.
3. **W4 — Suds Stack** — falling soap bars, tap to drop, stack them straight. Height + neatness = score. One mistimed drop = wobble.
4. **W5 — Lint Line (Simon)** — glowing lint tiles play a growing sequence; repeat it. Season 1 finale — memory game crowns the champion.
5. **W6 — Mop Hop** — side-scrolling mop hops over buckets and cats for 30s; near-misses give style points. Season 2 opener.

## 💡 Backlog
- Fur-nado Dodge (survive the swirling fur tornado)
- Sock Sort (match sock pairs against the clock)
- Squeegee Sprint (swipe to clear fog off a window, don't lift)
- Vacuum Maze (steer a robot vac through a room, battery draining)
- Grime Time II (Fur Frenzy remix, faster + boss stain)
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
