#!/usr/bin/env bash
# =============================================================
# w01_linux_essential — init.sh
# Sets up the treasure/ folder for the CLI Speed Challenge
# Run once: bash init.sh
# =============================================================

set -e

TREASURE="treasure"

# ── Guard: don't run twice ────────────────────────────────────
if [ -f "$TREASURE/.initialized" ]; then
  echo "⚠️  Lab already initialized."
  echo "   To reset: rm -rf treasure/ results/ && bash init.sh"
  exit 0
fi

echo "🚀 Initializing w01_linux_essential — Linux Essentials..."

# ── Directory structure ───────────────────────────────────────
mkdir -p "$TREASURE/logs"
mkdir -p "$TREASURE/configs"
mkdir -p "$TREASURE/archive/2024"
mkdir -p "$TREASURE/subdir/nested"
mkdir -p "results"

# ── Task 2: hidden file (ls -la) ─────────────────────────────
echo "API_KEY=dev-secret-do-not-share" > "$TREASURE/.env"
echo "DEBUG=true" >> "$TREASURE/.env"

# ── Task 3: hidden.txt for find ──────────────────────────────
echo "You found the hidden file using find!" > "$TREASURE/subdir/nested/hidden.txt"

# ── Task 4: files with realistic timestamps ──────────────────
# main files — created right now (will match -mmin -60)
echo "Current server config" > "$TREASURE/configs/server.conf"
echo "Database config" > "$TREASURE/configs/db.conf"

# archive files — touch with old timestamp (will NOT match -mmin -60)
echo "Old config backup" > "$TREASURE/archive/2024/old_server.conf"
touch -t 202401010000 "$TREASURE/archive/2024/old_server.conf"

# ── Task 5: data.txt with exactly 20 lines ───────────────────
printf '%s\n' \
  "line 1: alpha" \
  "line 2: bravo" \
  "line 3: charlie" \
  "line 4: delta" \
  "line 5: echo" \
  "line 6: foxtrot" \
  "line 7: golf" \
  "line 8: hotel" \
  "line 9: india" \
  "line 10: juliet" \
  "line 11: kilo" \
  "line 12: lima" \
  "line 13: mike" \
  "line 14: november" \
  "line 15: oscar" \
  "line 16: papa" \
  "line 17: quebec" \
  "line 18: romeo" \
  "line 19: sierra" \
  "line 20: tango" > "$TREASURE/data.txt"

# ── Task 6: fruits.txt with duplicates ───────────────────────
printf '%s\n' \
  "mango" \
  "apple" \
  "banana" \
  "mango" \
  "orange" \
  "apple" \
  "mango" \
  "grape" \
  "banana" \
  "kiwi" \
  "apple" \
  "mango" \
  "orange" \
  "grape" \
  "banana" > "$TREASURE/fruits.txt"
# mango:4, apple:3, banana:3, orange:2, grape:2, kiwi:1

# ── Task 8: extra files with varying modification times ──────
echo "readme content" > "$TREASURE/README.txt"
echo "notes from today" > "$TREASURE/notes.txt"
sleep 0.1
echo "info file" > "$TREASURE/info.txt"

# ── Task 10: access.log for challenge ────────────────────────
cat > "$TREASURE/logs/access.log" << 'LOGEOF'
192.168.1.10 GET /index.html 200
10.0.0.5 GET /login 200
192.168.1.10 POST /login 200
172.16.0.3 GET /about.html 200
10.0.0.5 GET /dashboard 404
192.168.1.10 GET /products 200
172.16.0.3 POST /contact 200
10.0.0.5 GET /index.html 200
192.168.1.10 GET /admin 403
10.0.0.7 GET /index.html 200
172.16.0.3 GET /login 200
192.168.1.10 DELETE /api/user 404
10.0.0.5 GET /products 200
172.16.0.3 GET /index.html 200
10.0.0.7 POST /login 404
192.168.1.10 GET /index.html 200
10.0.0.5 GET /about.html 200
172.16.0.3 GET /dashboard 404
10.0.0.7 GET /api/data 200
192.168.1.10 GET /products 200
LOGEOF
# Stats: 20 total, 4 unique IPs, 192.168.1.10=7 requests, 4 x 404

# ── Misc visible files ────────────────────────────────────────
echo "This is the treasure folder for w01_linux_essential." > "$TREASURE/README.txt"

# ── Mark initialized ─────────────────────────────────────────
date > "$TREASURE/.initialized"

echo ""
echo "✅ Lab environment ready!"
echo ""
echo "📂 Structure:"
find "$TREASURE" | sort | sed 's|[^/]*/|  |g'
echo ""
echo "👉 Open TASKS.md and start the lab."
echo "   Run: bash check.sh   to check your answers"
echo "   Run: bash submit.sh  to submit"
