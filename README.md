# My Claude Skills
Personal Claude skill library.

## Skills
- **gospel-study** — LDS gospel study, Come Follow Me, and talk writing using approved church sources.
- **mac-tuneup** — Safely diagnose and speed up a slow Mac. Read-only diagnosis first, explicit confirmation before any deletion, never touches user data. macOS only.

## Install
Claude Code loads skills from `~/.claude/skills/`. Clone this repo once, then link the skills you want into that folder so `git pull` keeps them current.

```bash
# One-time on each Mac
git clone https://github.com/kcferguson1/My-Claude-Skills.git ~/My-Claude-Skills
mkdir -p ~/.claude/skills

# Symlink the skills you want (pick any)
ln -s ~/My-Claude-Skills/mac-tuneup   ~/.claude/skills/mac-tuneup
ln -s ~/My-Claude-Skills/gospel-study ~/.claude/skills/gospel-study
```

Restart Claude Code, then invoke a skill by name (e.g. `/mac-tuneup`).

**Update later:**
```bash
cd ~/My-Claude-Skills && git pull   # symlinks pick up changes instantly
```

Prefer not to use symlinks? Copy instead — simpler, but re-copy after each pull:
```bash
cp -R ~/My-Claude-Skills/mac-tuneup ~/.claude/skills/
```
