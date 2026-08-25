# Uproot Arcade 🕹️🧹

One tiny browser game per week for the Uproot team. Hosted free as a Claude Artifact:

**Live link:** https://claude.ai/code/artifact/03f9f5a0-f8c9-455d-aa1b-67f7e9575098
(Share it from the page's share menu with **edit access** so teammates' sign-ups and scores save.)

## Rules
- **Sign up once**: name + `@uprootclean.com` email (no password). One account per email — the email's username part is the permanent account ID; the display name can be anything. Typing just the email username auto-fills the domain.
- **Returning players** just tap their name on the roster — no re-signup, ever.
- **Credits**: each player gets a set number of runs per week (`TRIES` constant — 3 for Week 1, tune it per game). Best run counts.
- **Scores never reset**: weekly winners earn 🏆, season standings rank by total of each week's best.
- **Scoreboard sidebar**: the 🏆 button (bottom-right) shows/hides the scoreboard — side column on desktop, slide-in drawer on phones. Keeps the full width free for future full-screen games. Per-device preference (`ua-sb` in localStorage).

## Folder layout
```
uproot-arcade/
  README.md
  week-01-fur-frenzy/uproot-arcade.html   ← Week 1 (30s pet-hair tap game)
  week-02-<game-name>/uproot-arcade.html  ← each new game gets its own folder
```

## Weekly update workflow (ask Claude)
1. Fetch the live artifact and copy every `<li>` inside `#roster-data` and `#score-data` into the new week's file — **this preserves the roster and all scores**.
2. Build the new game in a new `week-NN-<name>/` folder, bump `WEEK`, `GAME_NAME`, set `TRIES`, update the week chip label.
3. Republish to the SAME artifact URL (pass the URL when publishing from a new conversation or file path).

## Local testing
A static server config lives in `.claude/launch.json` (`arcade-preview`, port 8123):
open `http://localhost:8123/uproot-arcade/week-NN-<name>/uproot-arcade.html`.
On localhost there's no claude.ai runtime, so saves are device-only — the real save paths only run on the artifact link.

## Design system (keep consistent)
- Palette: bg `#150F2B`, panels `#221743`/`#2A1D52`, cyan `#2CE0DE`, pink `#F52C87`, purple `#8C4BFF`, lavender `#F2E9FF`, gold `#FFD23F`.
- Fonts (Google Fonts only — artifact CSP): Press Start 2P (headings/numbers/logo), Pixelify Sans (body; ligatures disabled — its "fi" ligature is broken), Silkscreen (labels/buttons).
- Logo: pixel-block CSS recreation of the brand art — cream outline, pink→purple extrusion, cyan UPROOT / yellow-orange ARCADE.
- Single dark theme, faint CRT scanlines.
