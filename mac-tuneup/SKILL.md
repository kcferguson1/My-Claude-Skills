---
name: mac-tuneup
description: "Safely diagnose and speed up a slow Mac. Use when the user wants to tune up / clean up / speed up their Mac, free disk space, reduce memory pressure, fix a slow Mac, or trim startup/login items. Read-only diagnosis first, then explicit per-step confirmation before any deletion. Never touches user data."
---

# /mac-tuneup

A safety-first macOS performance tune-up. The guiding principle: **diagnose first, delete nothing without explicit confirmation, and never touch the user's personal files.**

## Operating rules (non-negotiable)

1. **Read-only first.** Always run the diagnostic scan before proposing any change. Never delete based on assumptions.
2. **Confirm every deletion.** Use `AskUserQuestion` to let the user pick exactly what gets cleared. Never run `rm` on something the user hasn't seen and approved.
3. **Only delete regenerable data.** Caches, re-downloadable model files, package caches, and build artifacts. If it can't be re-created or re-downloaded automatically, it is NOT eligible — see the DENY list.
4. **Never touch user data.** Documents, Desktop *source files*, Photos library, Downloads media, Movies (user footage), Mail, Messages, anything in iCloud Drive, project *source code*. Project `node_modules`/`.next` build caches are OK to clear (restorable); project source is NEVER OK.
5. **Show size + last-used date before deleting.** Stale (months/years old) + large + regenerable = good candidate. Recently-used = leave it or ask pointedly.
6. **Don't run `sudo` yourself.** For system-level changes (e.g. `/Library/LaunchAgents`), print a copy-paste `sudo` command for the user to run. Don't trigger password prompts.
7. **Prefer reversible moves over deletes for config.** Disable login items by *moving* their `.plist` to `~/Library/LaunchAgents-disabled/`, not deleting — so it's trivially undoable.
8. **Explain APFS purgeable space.** Freed space often won't show in "Available" immediately — macOS marks it purgeable and reclaims on demand. Open file handles (apps still holding deleted files) and active writing also mask it. A **reboot** finalizes everything.

## Workflow

### Phase 1 — Diagnose (read-only)
Run the bundled scan and read the output:
```bash
bash ~/.claude/skills/mac-tuneup/scripts/diagnose.sh
```
From the output, identify the actual bottleneck(s):
- **Swap used ≈ total** and/or **low memory-free %** → RAM pressure is the main slowdown. Especially acute on 8GB machines.
- **Disk > ~85% full** → SSD/swap performance degrades; freeing space helps.
- **Heavy login items** (Adobe CC, Ollama, Docker, updaters) → loading before the user opens anything.
- **Large stale files** → reclaimable disk.

### Phase 2 — Report
Give the user a short, plain-language diagnosis (a small table works well) ranked by impact. State the single biggest lever first. Don't bury it in options.

### Phase 3 — Propose & confirm
Group fixes into categories and use `AskUserQuestion` (multiSelect) so the user picks. For each candidate show **size** and **last-used date**. Make clear everything offered is reversible/regenerable.

### Phase 4 — Execute (only what was approved)
- Measure free space before/after so the user sees the effect.
- For caches/models: delete *contents*, not the parent folder.
- For login items: move the `.plist` to `~/Library/LaunchAgents-disabled/` and `launchctl bootout gui/$(id -u)/<label>` to stop it now.
- For Ollama models: `ollama rm <model>` if the server runs, else remove `~/.ollama/models/blobs/*` and `manifests/*`.
- For system-level login items: print the `sudo mv ... ~/Library/LaunchAgents-disabled/` command for the user.

### Phase 5 — Wrap up
- Summarize what was done and space freed.
- If anything was deleted while apps were running, or swap was high, **recommend a reboot** to finalize purgeable space and clear swap. This is usually the most impactful final step.
- Give habit advice when RAM-constrained (e.g. on 8GB: don't run Chrome + an IDE + a local LLM at once).

## ALLOW list — safe to clear (with confirmation, after showing size/date)

| Item | Path | Regenerates by |
|---|---|---|
| User caches | `~/Library/Caches/*` | Apps rebuild automatically |
| Whisper models | `~/.cache/whisper/*` | Re-downloads on demand |
| Ollama models | `~/.ollama/models/*` | `ollama pull <model>` |
| Chrome on-device AI | `~/Library/Application Support/Google/Chrome/OptGuideOnDeviceModel` | Chrome re-downloads |
| Build caches | project `.next/cache`, `.next/dev/cache`, other build/dist caches | Next rebuild |
| `node_modules` (inactive projects) | per-project | `npm/pnpm/yarn install` |
| App media caches | e.g. `~/Movies/CapCut/User Data/Cache/*` | App re-creates |
| Package manager caches | `~/.npm/_cacache`, `~/Library/Caches/Homebrew`, `~/.cargo/registry/cache` | Re-downloads |
| Trash | `~/.Trash/*` | (confirm — user may want items back) |
| Stale GPS/map updater data | e.g. `~/Library/Application Support/Garmin` | Vendor app re-downloads |
| Redundant container runtime | e.g. `~/.colima` if Docker Desktop is the one in use | Recreated on next `colima start` |

## DENY list — NEVER delete (no exceptions)

- Anything in `~/Documents`, `~/Desktop` (source files), `~/Pictures`/Photos Library, `~/Downloads` media, `~/Movies` (user footage), `~/Music` library.
- Mail, Messages, Notes, Contacts, Calendar data stores.
- iCloud Drive contents.
- Project **source code** (only build caches / node_modules are eligible).
- VM/container images that back a tool the user actively uses (e.g. `~/Library/Application Support/Claude/.../rootfs.img` for Claude Code) unless the user explicitly says they no longer use that tool.
- `.env`, credentials, keychains, SSH keys, signing certs.
- Anything you can't confidently identify as regenerable. **When unsure, leave it and ask.**

## Notes
- This skill never installs third-party "cleaner" apps — those are unnecessary and often harmful. Everything here is built-in macOS tooling.
- If `du`/`find` over `$HOME` is slow on a huge disk, scope to the suspected folders rather than scanning everything.
