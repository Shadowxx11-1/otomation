# Madness BiomeSniperX — Desktop

A standalone Windows/macOS/Linux app that watches Discord channels in the background and launches
Roblox **directly** the moment a matching Sol's RNG biome / merchant link appears. No browser, no
Tampermonkey, no "Open Roblox?" prompt — the app hands the link straight to the Roblox client.

## Quick start

```bash
npm install
npm start            # run it
npm run dist         # build an installer + portable .exe into /dist (Windows)
npm test             # 42 automated checks (detection, gate, pipeline, UI)
```

First run:
1. **Channels → Sign in to Discord.** Log in normally in the window that opens (remembered afterwards).
2. In Discord, right-click your biome channel → **Copy Link**, paste it under **Channels → Add a channel**.
3. Pick targets under **Biomes**. Defaults: Glitched, Dreamspace, Cyberspace, Singularity, Radiant Forest, Sinister.
4. Done. The Discord window hides itself after login; the app lives in the system tray.

## How it works (and why it's fast)

* Each watched channel runs in its own Discord window with throttling disabled. A MutationObserver reads
  new messages in the same JavaScript turn Discord renders them (~11 µs of analysis per message).
* The hand-off to the main process is one IPC message; `shell.openExternal('roblox://…')` starts Roblox.
  Every launch link is rebuilt by the app and checked against a strict allow-list before it is opened.
* **Live-only:** whatever is on screen when a channel opens counts as old, and messages older than your
  freshness window (default 15 s, measured against Discord's server clock) are never read.
* **Safety:** join lock (default 2 min, release any time), duplicate protection across all channels,
  spam guard, priority pick (only the rarest of simultaneous links opens), user filters.
* **Detection:** typo-tolerant, context-aware ("not here", "ended", "dont miss"), 100% local — no online AI.

## Privacy & security

* You sign in inside Discord's own page. The app never asks for, reads or stores your token.
* It only reads messages Discord already renders in its own window; it sends nothing to Discord.
* The Discord windows expose no API to the page, block navigation away from discord.com, and deny
  all permission requests. The optional webhook (your own URL) never includes links or user names.

## Troubleshooting

* **Channel shows "Loading…" or "Sign-in needed"** — click *Show window* next to it and sign in.
* **Nothing is detected while hidden** — set *Channels → Window mode* to *Minimized* or *Visible*, then check
  the Dashboard: a healthy channel is "Live" and the Settings → Diagnostics show recent activity.
* **Roblox doesn't open** — Settings → *Test Roblox launch*. Roblox must be installed for the current user.

Hotkeys (toggle in Settings): `Ctrl+Alt+S` pause/resume · `Ctrl+Alt+L` release join lock · `Ctrl+Alt+O` open last link.
