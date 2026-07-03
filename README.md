# w01_basic_cli — Linux Essentials for Developers

**Course:** 204203 Computer Science Technology  
**Week:** 1  
**Theme:** *"You already know the basics. Now learn what LabEx didn't cover."*

---

## What You Will Learn

This lab assumes you have completed **LabEx Linux Journey Part 1**.  
Basic navigation (`pwd`, `ls`, `cd`, `cp`, `mv`) is treated as prior knowledge.

This lab focuses on what comes next:

| Section | Skills |
|---------|--------|
| 1 — Navigation | Absolute vs relative paths, `ls -la`, hidden files |
| 1.3 — Home & Dotfiles | `.bashrc`, `.bash_profile`, `.bash_aliases`, `history`, `alias` |
| 1.4 — Reading Files | `cat`, `less`, `head`, `tail`, `tail -f`, `which` |
| 2 — Finding Files | `find` by name, wildcard, type, and modification time |
| 3 — Counting and Sorting | `wc`, `sort`, `uniq -c`, frequency analysis |
| 4 — Redirection | `>` vs `>>`, command substitution with `$()` |
| 5 — Reading the Manual | Using `man`, `--help`, and `/` search to find unfamiliar flags |
| 6 — Pipes | Chaining commands with `\|`, no temp files |
| 7 — Challenge | Log analysis using pipes, plus a first look at `cut` and `grep` |

---

## Getting Started

You can do this lab two ways: entirely in the browser with a **GitHub Codespace**, or on **your VM** from `w00_setup` over SSH. Pick one track below — Steps 3 onward are identical either way.

| | Codespace | VM |
|---|---|---|
| Where the terminal runs | Browser | Your VM (`10.110.x.x`), connected from the lab machine |
| How you get the code | Click **Use this template** on GitHub | `git clone` by hand |
| Setup time | ~1 minute | ~2 minutes |
| Requires | Nothing extra | `w00_setup` already completed (SSH key, `gh auth login`, git identity) |

> ⚠️ **Two machines, if you use the VM track:** the lab machine is shared and stores nothing. Your VM is where your SSH key, `gh` login, and code live. You connect lab machine → VM with a password every session, same as `w00_setup`.

---

### Track A — GitHub Codespace

#### A1 — Create Your Repo from the Template

This repository is a **template** inside the **204203-2026** organization.  
You must create your own copy — do not work directly in the template.

1. Make sure you are logged into GitHub and have joined **204203-2026**  
   *(you did this in w00_setup — if not, ask your instructor)*
2. Click the green **Use this template** button at the top of this page
3. Click **Create a new repository**
4. Under **Owner** — select **204203-2026** (not your personal account)
5. Set the repository name to `w01_basic_cli-STUDENTID`  
   Replace `STUDENTID` with your 9-digit student ID  
   Example: `w01_basic_cli-640123456`
6. Set visibility to **Private**
7. Click **Create repository**

Your repo will be at:  
`https://github.com/204203-2026/w01_basic_cli-640123456`

> ⚠️ Owner must be **204203-2026**, not your personal account.  
> Wrong owner = instructor cannot see your submission = no grade.

---

#### A2 — Open in GitHub Codespace

1. Go to your newly created repo
2. Click the green **Code** button
3. Click the **Codespaces** tab
4. Click **Create codespace on main**
5. Wait 30–60 seconds for the environment to load

A full Ubuntu Linux terminal opens in your browser — no installation needed.

> 💡 If you do not see the terminal: **View → Terminal** or press `` Ctrl+` ``

Skip to **Step 3 — Set Up the Lab Environment** below.

---

### Track B — Your VM

Do this from the lab machine, connected to your VM — the same setup as `w00_setup`.

#### B1 — Connect to Your VM

From a terminal on the lab machine:

```bash
ssh user6805xxxxx@10.110.x.x
```

Replace `user6805xxxxx` and `10.110.x.x` with your own username and VM IP. Enter your password when prompted.

Confirm you are on the VM — your prompt should read `user6805xxxxx@user6805xxxxx:~$`.

---

#### B2 — Clone the Template

Confirm GitHub CLI is still using HTTPS (outbound SSH may be blocked on the lab network):

```bash
gh auth status
# Git operations protocol: https
```

Clone the **template repository** into a folder named after your own submission repo. Replace `6805xxxxx` with your student ID:

```bash
git clone https://github.com/204203-2026/w01_basic_cli.git w01_basic_cli-6805xxxxx
cd w01_basic_cli-6805xxxxx
```

---

#### B3 — Detach from the Template's Git History

The clone still points at the template's history and remote. Remove it and start fresh:

```bash
rm -rf .git
git init
git branch -M main
```

This folder is now a plain directory with no Git history — you are about to make it your own repository.

---

#### B4 — Create Your Own Repository on GitHub

Check whether your submission repo already exists:

```bash
gh repo view 204203-2026/w01_basic_cli-6805xxxxx
```

If you see repository info, it already exists — continue to B5.

If you see `repository not found`, create it:

```bash
gh repo create 204203-2026/w01_basic_cli-6805xxxxx --private
```

> ⚠️ Owner must be **204203-2026**, not your personal account.  
> Do not add a README, `.gitignore`, or license — this local folder already has everything.

---

#### B5 — Add the Remote and Push

Point this local folder at your new GitHub repository:

```bash
git remote add origin https://github.com/204203-2026/w01_basic_cli-6805xxxxx.git
git remote -v   # confirm origin points at YOUR repo, not the template
```

Since this repo ships a GitHub Actions workflow, refresh your token scope so the push isn't rejected:

```bash
gh auth refresh -h github.com -s workflow
```

Commit and push the starting files:

```bash
git add .
git commit -m "Start w01_basic_cli"
git push -u origin main
```

You now have your own copy of the lab, pushed to GitHub, with a normal terminal open on your VM.

---

### Step 3 — Set Up the Lab Environment

Run this once in the terminal:

```bash
bash init.sh
```

This creates the `treasure/` folder with all files needed for the lab.  
You will see a confirmation and a directory listing when it is done.

---

### Step 4 — Follow the Lab Tasks

Open `TASKS.md` and work through each section in order.  
Every section explains the concept, shows examples, then asks you to save a result.

---

### Step 5 — Check Your Work

Run at any time to see your current score:

```bash
bash check.sh
```

You can run this as many times as you want. It shows PASS or FAIL per task  
and tells you exactly what went wrong if something fails.

---

### Step 6 — Submit

When you are ready:

```bash
bash submit.sh
```

This validates your results, commits, and pushes to GitHub.  
GitHub Actions then runs automatically — check the **Actions tab** in your repo to confirm.

---

## File Structure

```
w01_basic_cli/
├── README.md              ← you are here
├── TASKS.md               ← lab instructions (follow this)
├── init.sh                ← run once to set up treasure/
├── check.sh               ← run anytime to check your answers
├── submit.sh              ← run when ready to submit
├── treasure/              ← created by init.sh — do not delete
│   ├── .env               ← hidden config file (Task 2)
│   ├── data.txt           ← 20-line data file (Task 5)
│   ├── fruits.txt         ← file with duplicates (Task 6)
│   ├── configs/           ← config files (Task 4)
│   ├── archive/2024/      ← old files with past timestamps (Task 4)
│   ├── subdir/nested/
│   │   └── hidden.txt     ← file to find with find (Task 3)
│   └── logs/
│       └── access.log     ← web server log (Task 10 challenge)
└── results/               ← your answers go here — created by init.sh
    ├── task1.txt
    ├── task2.txt
    ├── task3.txt
    ├── task4.txt
    ├── task4b.txt
    ├── task5.txt
    ├── task5b.txt
    ├── task6.txt
    ├── task7.txt
    ├── task7b.txt
    ├── task8.txt
    ├── task8b.txt
    ├── task9.txt
    ├── task10.txt
    ├── task10b.txt
    ├── task11.txt
    ├── task12a.txt
    ├── task12b.txt
    ├── task12c.txt
    ├── task12d.txt
    └── results.log        ← written by check.sh — do not edit manually
```

---

## Task Summary

| Task | Section | Command(s) Used | Save to |
|------|---------|-----------------|---------|
| 1 | 1.1 | `pwd` | `results/task1.txt` |
| 2 | 1.2 | `ls -la` | `results/task2.txt` |
| 3 | 1.3 | `alias`, `.bash_aliases` | `results/task3.txt` |
| 4 | 1.4 | `head -n 5`, `which` | `results/task4.txt`, `task4b.txt` |
| 5 | 2.1 | `find -name` | `results/task5.txt`, `task5b.txt` |
| 6 | 2.2 | `find -mmin` | `results/task6.txt` |
| 7 | 3.1 | `wc -l <` | `results/task7.txt`, `task7b.txt` |
| 8 | 3.2 | `sort \| uniq` | `results/task8.txt`, `task8b.txt` |
| 9 | 4.1 | `echo`, `>>`, `$()` | `results/task9.txt` |
| 10 | 5.1 | `man ls`, `ls -lt` | `results/task10.txt`, `task10b.txt` |
| 11 | 6.1 | `find \| wc -l` | `results/task11.txt` |
| 12 | 7 | pipes, plus `cut`/`grep` | `results/task12a–d.txt` |

---

## Common Mistakes

**Task 4 — `head` output doesn't match**  
The grader compares your file byte-for-byte against `head -n 5 treasure/data.txt`.  
Don't retype the lines by hand — redirect the command's output directly.

**Task 7 — line count includes filename**  
`wc -l treasure/data.txt` saves `20 treasure/data.txt`.  
Use `wc -l < treasure/data.txt` instead — the `<` gives just `20`.

**Task 9 — overwrite instead of append**  
Using `>` more than once erases the previous line.  
After the first line, always use `>>`.

**Task 10 — guessing the flag instead of using `man`**  
The grader checks `task10b.txt` for the flag name.  
Open `man ls`, type `/sort`, press `n` to find the `-t` flag.

**Task 12 — writing a script instead of using pipes**  
Section 7 must be solved with a single pipeline per question.  
Re-read Section 3.2 and Section 6 if you are stuck.

**Submitting before checking**  
`submit.sh` requires `results.log` to exist.  
Always run `bash check.sh` before `bash submit.sh`.

---

## Grading

`check.sh` runs on your machine and writes `results/results.log`.  
`submit.sh` pushes it to GitHub.  
GitHub Actions re-verifies key tasks independently:

| What Actions checks | Why |
|---------------------|-----|
| `results.log` exists and has all 12 tasks | Submission completeness |
| `task4.txt` matches `head -n 5 treasure/data.txt` | Verifies correct `head` usage |
| `task7.txt` contains exactly `20` | Verifies `wc -l <` not `wc -l file` |
| `task8.txt` has no duplicates | Verifies `sort \| uniq` was used |
| `task9.txt` has all 4 required sections | Verifies `>>` append pattern |
| `task12a–d.txt` match expected values | Re-runs log analysis independently |

Your score in the Actions tab is the official grade.

---

## Getting Help

```bash
man <command>       # full manual — press / to search, q to quit
<command> --help    # quick flag summary
```

If `check.sh` says FAIL, read the message carefully — it tells you  
which file is missing or what the expected value is.

If you are stuck on Section 7, re-read:
- Section 3.2 for the `sort | uniq -c | sort -rn | head -1` pattern
- Section 6 for pipe chaining examples
- Lecture slides 26–29 for the same patterns with explanation
