# Uproot Arcade 🕹️🧹

One tiny browser game per week for the Uproot team. Fully public — anyone can open it, play, and post scores. No sign-in, ever.

**Play here:** https://dharmesh7063-cmd.github.io/uproot-arcade/

## How it works
- **Sign up once**: display name + `@uprootclean.com` email + a secret **4-digit PIN**. Typing just the email username auto-fills the domain. One account per email — enforced by the database.
- **Returning players** tap their name and enter their PIN ("prove it's you"). A verified device remembers you.
- **PIN security**: only a hash is stored, in a write-once column the public key cannot read; verification runs server-side (`check_pin`). Pre-PIN accounts get a one-shot claim flow.
- **Forgot PIN → reset = NEW LIFE**: your old account becomes a ghost 👻 that keeps every score forever, and you restart the season at zero. If you later remember the old PIN, entering it signs you back into the ghost, scores intact. Weekly credits are counted per *email* across lives, so resetting never grants extra runs.
- **Credits**: each player gets a set number of runs per week (the `games` table row for that week — 3 for Week 1). Best run counts. The credit cap is enforced server-side; the 4th attempt is rejected.
- **Scores never reset**: every run ever played is stored permanently. Weekly winners earn 🏆; season standings rank by the total of each week's best.
- **Scoreboard sidebar**: the 🏆 button shows/hides it (side column on desktop, drawer on phones) so full-screen games get the whole canvas.

## Architecture (all free tiers)
- **Hosting**: GitHub Pages — repo `dharmesh7063-cmd/uproot-arcade`, `main` branch root. Push = deploy (~1 min; CDN cache up to 10 min).
- **Data**: Supabase project `cofdyguyfltehvbdigok` — tables `games`, `roster`, `scores` (schema: [supabase-setup.sql](supabase-setup.sql)). Row Level Security: everyone reads, inserts only within the rules, no updates/deletes — history is tamper-proof. The publishable key embedded in the page is public by design.
- Saves are instant (REST inserts); the scoreboard live-refreshes every 45s and on tab focus; offline runs queue in the browser and auto-post later.

## Folder layout
```
uproot-arcade/
  README.md
  supabase-setup.sql                 ← database schema + rules
  index.html                         ← the CURRENT week's game (site root)
  week-01-fur-frenzy/index.html      ← each game's permanent home
```

## Weekly update workflow (ask Claude)
1. Build the new game in `week-NN-<name>/index.html` (bump `WEEK`, `GAME_NAME`, week-chip label, "This week" heading).
2. Add the week's row to the `games` table (`week`, `name`, `tries`) — paste one INSERT in the Supabase SQL Editor. This sets that week's credit count.
3. `cp week-NN-<name>/index.html index.html` → commit → push. Done; scores and roster carry over automatically because they live in the database.

## Notes
- Database schema changes require the Supabase dashboard SQL Editor (Dharmesh's account).
- The old claude.ai artifact link now shows a "we've moved" page pointing here.
