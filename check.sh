#!/usr/bin/env bash
# =============================================================
# w01_linux_essential — check.sh
# Self-check script. Run on your own machine anytime.
# Writes results/results.log
# =============================================================
# No set -e — this script handles errors intentionally

RESULTS="results"
LOG="$RESULTS/results.log"
TREASURE="treasure"

PASS=0
FAIL=0
TOTAL=12

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ── Guard ────────────────────────────────────────────────────
if [ ! -f "$TREASURE/.initialized" ]; then
  echo -e "${RED}❌ Lab not initialized. Run: bash init.sh${NC}"
  exit 1
fi

mkdir -p "$RESULTS"
> "$LOG"

echo "=============================================="
echo "  w01_linux_essential — Self Check"
echo "=============================================="
echo ""

# ── Helper ───────────────────────────────────────────────────
record() {
  local task=$1 status=$2 msg=$3
  echo "${task}:${status}" >> "$LOG"
  if [ "$status" = "PASS" ]; then
    echo -e "${GREEN}✅ $task PASS${NC} — $msg"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}❌ $task FAIL${NC} — $msg"
    FAIL=$((FAIL + 1))
  fi
}

section() {
  echo ""
  echo -e "${CYAN}── $1 ──${NC}"
}

# ════════════════════════════════════════════════════════════
section "Part 1 — Navigation Recap"

# Task 1: pwd output is an absolute path
if [ -f "$RESULTS/task1.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task1.txt")
  if [[ "$val" == /* ]]; then
    record "task1" "PASS" "Absolute path found: $val"
  else
    record "task1" "FAIL" "Not an absolute path — run: pwd > results/task1.txt"
  fi
else
  record "task1" "FAIL" "results/task1.txt missing — run: pwd > results/task1.txt"
fi

# Task 2: ls -la must show "total" line AND hidden file entries
# In ls -la, hidden filenames appear at END of lines (e.g. "drwxr-xr-x ... .env")
if [ -f "$RESULTS/task2.txt" ]; then
  has_total=$(grep -c "^total" "$RESULTS/task2.txt" 2>/dev/null || echo 0)
  has_hidden=$(grep -cE ' \.[^ /]+$' "$RESULTS/task2.txt" 2>/dev/null || echo 0)
  if [ "$has_total" -ge 1 ] && [ "$has_hidden" -ge 1 ]; then
    record "task2" "PASS" "Long listing with hidden files found (-la used correctly)"
  elif [ "$has_total" -eq 0 ]; then
    record "task2" "FAIL" "Missing total line — use ls -la (long format), not just ls -a"
  else
    record "task2" "FAIL" "No hidden files visible — use ls -la treasure/"
  fi
else
  record "task2" "FAIL" "results/task2.txt missing — run: ls -la treasure/ > results/task2.txt"
fi

# ════════════════════════════════════════════════════════════
section "Part 2 — Home Directory, Dotfiles, and Reading Files"

# Task 3: alias definition recorded (Section 1.3)
if [ -f "$RESULTS/task3.txt" ]; then
  if grep -qi "alias" "$RESULTS/task3.txt" && grep -q "ls -la" "$RESULTS/task3.txt"; then
    record "task3" "PASS" "Alias definition recorded: $(tr -d '\n' < "$RESULTS/task3.txt")"
  else
    record "task3" "FAIL" "Missing alias definition — run: echo \"alias ll='ls -la'\" > results/task3.txt"
  fi
else
  record "task3" "FAIL" "results/task3.txt missing — see Section 1.3"
fi

# Task 4: head -n 5 exact match + which output is a real path (Section 1.4)
if [ -f "$RESULTS/task4.txt" ] && [ -f "$RESULTS/task4b.txt" ]; then
  expected=$(head -n 5 "$TREASURE/data.txt")
  actual=$(cat "$RESULTS/task4.txt")
  which_val=$(tr -d '[:space:]' < "$RESULTS/task4b.txt")
  if [ "$actual" = "$expected" ] && [[ "$which_val" == /* ]]; then
    record "task4" "PASS" "head -n 5 output correct and which path found: $which_val"
  elif [ "$actual" != "$expected" ]; then
    record "task4" "FAIL" "task4.txt doesn't match — run: head -n 5 treasure/data.txt > results/task4.txt"
  else
    record "task4" "FAIL" "task4b.txt should be a path starting with / — run: which ls > results/task4b.txt"
  fi
else
  record "task4" "FAIL" "results/task4.txt or task4b.txt missing — see Section 1.4"
fi

# ════════════════════════════════════════════════════════════
section "Part 3 — Finding Files"

# Task 5: find hidden.txt
if [ -f "$RESULTS/task5.txt" ]; then
  if grep -q "hidden.txt" "$RESULTS/task5.txt"; then
    found=$(grep "hidden.txt" "$RESULTS/task5.txt" | head -1 | tr -d '[:space:]')
    if [ -f "$found" ]; then
      record "task5" "PASS" "Valid path to hidden.txt: $found"
    else
      record "task5" "FAIL" "Path '$found' does not exist — re-run find from the lab directory"
    fi
  else
    record "task5" "FAIL" "hidden.txt not found in task5.txt — run: find treasure/ -name \"hidden.txt\""
  fi
else
  record "task5" "FAIL" "results/task5.txt missing"
fi

# Task 6: find by modification time — should have results since files were just created
if [ -f "$RESULTS/task6.txt" ]; then
  count=$(wc -l < "$RESULTS/task6.txt" | tr -d '[:space:]')
  if [ "$count" -gt 0 ] 2>/dev/null; then
    record "task6" "PASS" "Found $count recently modified files"
  else
    record "task6" "FAIL" "No files found — the treasure/ files were just created, try -mmin -60"
  fi
else
  record "task6" "FAIL" "results/task6.txt missing — run: find treasure/ -mmin -60 -type f > results/task6.txt"
fi

# ════════════════════════════════════════════════════════════
section "Part 4 — Counting and Sorting"

# Task 7: wc -l < treasure/data.txt — must be exactly 20, no filename
if [ -f "$RESULTS/task7.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task7.txt")
  if [ "$val" = "20" ]; then
    record "task7" "PASS" "Correct line count: 20 (no filename)"
  elif echo "$val" | grep -q "20"; then
    record "task7" "FAIL" "Got '$val' — looks right but has extra text. Use: wc -l < treasure/data.txt (with <)"
  else
    record "task7" "FAIL" "Expected 20, got '$val'"
  fi
else
  record "task7" "FAIL" "results/task7.txt missing — run: wc -l < treasure/data.txt > results/task7.txt"
fi

# Task 8: sort | uniq — no duplicates, sorted alphabetically
if [ -f "$RESULTS/task8.txt" ]; then
  # Check no duplicates exist
  dupes=$(sort "$RESULTS/task8.txt" | uniq -d | wc -l | tr -d '[:space:]')
  # Check it is sorted
  sorted_check=$(sort "$RESULTS/task8.txt")
  file_content=$(cat "$RESULTS/task8.txt")
  if [ "$dupes" = "0" ] && [ "$sorted_check" = "$file_content" ]; then
    lines=$(wc -l < "$RESULTS/task8.txt" | tr -d '[:space:]')
    record "task8" "PASS" "Correct: $lines unique fruits, sorted alphabetically"
  elif [ "$dupes" != "0" ]; then
    record "task8" "FAIL" "Duplicates still present — did you use: sort treasure/fruits.txt | uniq"
  else
    record "task8" "FAIL" "No duplicates but not sorted — did you sort first?"
  fi
else
  record "task8" "FAIL" "results/task8.txt missing — run: sort treasure/fruits.txt | uniq > results/task8.txt"
fi

# ════════════════════════════════════════════════════════════
section "Part 5 — Redirection"

# Task 9: results/task9.txt has all 4 required lines
if [ -f "$RESULTS/task9.txt" ]; then
  has_header=$(grep -c "=== Lab Summary ===" "$RESULTS/task9.txt" || true)
  has_user=$(grep -c "^User:" "$RESULTS/task9.txt" || true)
  has_date=$(grep -c "^Date:" "$RESULTS/task9.txt" || true)
  has_count=$(grep -c "^Lines in data.txt:" "$RESULTS/task9.txt" || true)

  if [ "$has_header" -ge 1 ] && [ "$has_user" -ge 1 ] && [ "$has_date" -ge 1 ] && [ "$has_count" -ge 1 ]; then
    record "task9" "PASS" "Summary file has all 4 required sections"
  else
    record "task9" "FAIL" "task9.txt is missing sections. Need: header, User:, Date:, Lines in data.txt:"
  fi
else
  record "task9" "FAIL" "results/task9.txt missing — follow Task 9 steps in TASKS.md"
fi

# ════════════════════════════════════════════════════════════
section "Part 6 — Read the Manual"

# Task 10: ls with time-sort flag — accept -t or --sort=time
if [ -f "$RESULTS/task10.txt" ]; then
  if [ -f "$RESULTS/task10b.txt" ]; then
    flag=$(tr -d '[:space:]' < "$RESULTS/task10b.txt" | grep -oE '\-[a-zA-Z]+|--sort=[a-z]+' | head -1)
    # Accept -t or -lt or -lat or --sort=time
    if echo "$flag" | grep -qE '(-[a-zA-Z]*t[a-zA-Z]*|--sort=time)'; then
      record "task10" "PASS" "Correct flag used: $flag"
    else
      record "task10" "FAIL" "Flag '$flag' doesn't look like a time-sort flag — check man ls, search for 'time'"
    fi
  else
    record "task10" "FAIL" "results/task10b.txt missing — save the flag you used: echo \"I used the flag: -t\" > results/task10b.txt"
  fi
else
  record "task10" "FAIL" "results/task10.txt missing — run ls with the time-sort flag you found in man ls"
fi

# ════════════════════════════════════════════════════════════
section "Part 7 — Pipes"

# Task 11: count of files under treasure/
if [ -f "$RESULTS/task11.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task11.txt")
  # The actual count depends on what find treasure/ returns
  actual=$(find treasure/ | wc -l | tr -d '[:space:]')
  if [ "$val" = "$actual" ]; then
    record "task11" "PASS" "Correct count: $val items under treasure/"
  else
    record "task11" "FAIL" "Expected $actual, got '$val' — run: find treasure/ | wc -l > results/task11.txt"
  fi
else
  record "task11" "FAIL" "results/task11.txt missing — run: find treasure/ | wc -l > results/task11.txt"
fi

# ════════════════════════════════════════════════════════════
section "Part 8 — Challenge Round"

# Task 12: access.log analysis — check all 4 answers
LOG_FILE="$TREASURE/logs/access.log"
ALL_12_PASS=true

# 12a: total lines = 20
if [ -f "$RESULTS/task12a.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task12a.txt")
  expected=$(wc -l < "$LOG_FILE" | tr -d '[:space:]')
  if [ "$val" = "$expected" ]; then
    echo -e "  ${GREEN}✓ 12a: total requests = $val${NC}"
  else
    echo -e "  ${RED}✗ 12a: expected $expected, got '$val'${NC}"
    ALL_12_PASS=false
  fi
else
  echo -e "  ${RED}✗ 12a: results/task12a.txt missing${NC}"
  ALL_12_PASS=false
fi

# 12b: unique IPs = 4
if [ -f "$RESULTS/task12b.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task12b.txt")
  expected=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l | tr -d '[:space:]')
  if [ "$val" = "$expected" ]; then
    echo -e "  ${GREEN}✓ 12b: unique IPs = $val${NC}"
  else
    echo -e "  ${RED}✗ 12b: expected $expected unique IPs, got '$val'${NC}"
    ALL_12_PASS=false
  fi
else
  echo -e "  ${RED}✗ 12b: results/task12b.txt missing${NC}"
  ALL_12_PASS=false
fi

# 12c: most active IP = 192.168.1.10
if [ -f "$RESULTS/task12c.txt" ]; then
  if grep -q "192.168.1.10" "$RESULTS/task12c.txt"; then
    echo -e "  ${GREEN}✓ 12c: most active IP identified correctly${NC}"
  else
    echo -e "  ${RED}✗ 12c: wrong IP — expected 192.168.1.10${NC}"
    ALL_12_PASS=false
  fi
else
  echo -e "  ${RED}✗ 12c: results/task12c.txt missing${NC}"
  ALL_12_PASS=false
fi

# 12d: count of 404s = 4
if [ -f "$RESULTS/task12d.txt" ]; then
  val=$(tr -d '[:space:]' < "$RESULTS/task12d.txt")
  expected=$(grep -c " 404$" "$LOG_FILE" | tr -d '[:space:]')
  if [ "$val" = "$expected" ]; then
    echo -e "  ${GREEN}✓ 12d: 404 count = $val${NC}"
  else
    echo -e "  ${RED}✗ 12d: expected $expected, got '$val'${NC}"
    ALL_12_PASS=false
  fi
else
  echo -e "  ${RED}✗ 12d: results/task12d.txt missing${NC}"
  ALL_12_PASS=false
fi

if $ALL_12_PASS; then
  record "task12" "PASS" "All 4 log analysis questions answered correctly"
else
  record "task12" "FAIL" "One or more log analysis answers incorrect — see details above"
fi

# ════════════════════════════════════════════════════════════
echo ""
echo "=============================================="
echo -e "  Score: ${GREEN}${PASS}${NC} / ${TOTAL}   |   ${RED}${FAIL}${NC} failed"
echo "=============================================="
echo ""
echo "📄 Log: $LOG"
echo ""

if [ "$FAIL" -eq 0 ]; then
  echo -e "${GREEN}🎉 All tasks passed! Run: bash submit.sh${NC}"
else
  echo -e "${YELLOW}⚠️  Fix failing tasks, then run bash check.sh again.${NC}"
  echo ""
  echo "Stuck? Re-read the relevant section in TASKS.md."
  echo "The 📖 Concept and 💡 Example sections explain every command."
fi
