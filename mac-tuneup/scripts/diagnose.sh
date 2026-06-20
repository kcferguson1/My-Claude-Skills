#!/usr/bin/env bash
# mac-tuneup diagnostics — READ ONLY. Never deletes or modifies anything.
# Prints a snapshot of what's slowing the Mac down: hardware, memory pressure,
# swap, disk usage, biggest files/folders, login items, and reclaimable caches.

set -uo pipefail
HOME_DIR="${HOME}"

hr() { printf '\n=== %s ===\n' "$1"; }

hr "Hardware / OS"
sw_vers 2>/dev/null
system_profiler SPHardwareDataType 2>/dev/null | grep -E "Model Name|Chip|Processor|Memory|Total Number of Cores"

hr "Uptime / Load"
uptime

hr "Memory pressure"
memory_pressure 2>/dev/null | tail -3
echo "(High pageouts or low free % = RAM is the bottleneck)"

hr "Swap usage"
sysctl vm.swapusage 2>/dev/null
echo "(used near total = the Mac is paging to disk; a reboot clears it)"

hr "Disk — real free space (purgeable-aware)"
diskutil info /System/Volumes/Data 2>/dev/null | grep -iE "Volume Used Space|Container Free Space"
df -h /System/Volumes/Data 2>/dev/null | tail -1 | awk '{print "  df view -> Used: "$3"  Avail: "$4"  ("$5" full)"}'

hr "APFS local snapshots (can hold deleted space hostage)"
tmutil listlocalsnapshots / 2>/dev/null | grep -i snapshot || echo "  None."

hr "Top CPU processes"
ps -Aceo pcpu,pmem,comm -r 2>/dev/null | head -10

hr "Top MEM processes"
ps -Aceo pmem,pcpu,comm -m 2>/dev/null | head -10

hr "Login items — user level (~/Library/LaunchAgents)"
ls -1 "${HOME_DIR}/Library/LaunchAgents" 2>/dev/null | sed 's/\.plist$//; s/^/  • /' || echo "  none"

hr "Login items — system level (/Library/LaunchAgents)"
ls -1 /Library/LaunchAgents 2>/dev/null | sed 's/\.plist$//; s/^/  • /' || echo "  none"

hr "Biggest home folders (top 15)"
du -sh "${HOME_DIR}"/* 2>/dev/null | sort -rh | head -15

hr "Biggest individual files >100MB (top 25)"
find "${HOME_DIR}" -type f -size +100M 2>/dev/null -exec du -h {} + 2>/dev/null | sort -rh | head -25

hr "Reclaimable cache locations (sizes only — NOT deleted)"
for p in \
  "${HOME_DIR}/Library/Caches" \
  "${HOME_DIR}/.cache/whisper" \
  "${HOME_DIR}/.ollama/models" \
  "${HOME_DIR}/Library/Application Support/Google/Chrome/OptGuideOnDeviceModel" \
  "${HOME_DIR}/.Trash" ; do
  [ -e "$p" ] && du -sh "$p" 2>/dev/null
done

hr "node_modules / build caches (top 10 — restorable via reinstall/rebuild)"
{ find "${HOME_DIR}" -type d \( -name node_modules -o -name ".next" \) -prune 2>/dev/null | while read -r d; do du -sh "$d" 2>/dev/null; done ; } | sort -rh | head -10

echo
echo "=== DONE (nothing was changed) ==="
