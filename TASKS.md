# w01_linux_essential — Linux Essentials

**Course:** 204203 Computer Science Technology  
**Theme:** *"You already know the basics. Now learn what LabEx didn't cover."*

> **Setup:** run `bash init.sh` before starting.  
> **Check anytime:** run `bash check.sh`  
> **Submit:** run `bash submit.sh`

All lab files live inside the `treasure/` folder created by `init.sh`.  
All your answers go into the `results/` folder.

---

## Section 1 — Where Are You and What Is Here?

You have used `pwd` and `ls` before. This section focuses on the parts that catch developers off guard.

### 1.1 Absolute vs Relative Paths

There are two ways to refer to any file in Linux:

- An **absolute path** starts from the root `/` and works from anywhere
- A **relative path** starts from where you currently are and only works from that location

1. Check where you are right now:

```bash
pwd
```

This prints your current working directory — an absolute path starting with `/`.

2. Try referring to the same file two ways:

```bash
# Absolute path — always works no matter where you are
cat /etc/hostname

# Relative path — only works from the right location
cat treasure/README.txt
```

The absolute path `/etc/hostname` works from any directory. The relative path `treasure/README.txt` only works if you are in the lab folder.

3. Save your current location:

```bash
pwd > results/task1.txt
```

This saves your absolute path for grading.

---

### 1.2 Listing Files — Including the Hidden Ones

By default `ls` hides files whose names start with a dot (`.`). These are called **hidden files** and are widely used for config files, environment variables, and secrets.

1. List only the visible files:

```bash
ls treasure/
```

You will see files like `data.txt`, `fruits.txt`, `README.txt` — but not everything.

2. Now list ALL files including hidden ones:

```bash
ls -a treasure/
```

You will now see `.env` and `.initialized` appearing. These were always there — just hidden.

3. Use long format to see permissions, owner, size, and date:

```bash
ls -la treasure/
```

Each line shows: `permissions  links  owner  group  size  date  filename`.  
The `-la` combines `-l` (long format) and `-a` (all files). You can also write it as `-al` — the order does not matter.

4. Save the full listing:

```bash
ls -la treasure/ > results/task2.txt
```

---

### 1.3 Your Home Directory and Dotfiles

Your home directory (`~`, e.g. `/home/student`) is your personal space in the filesystem. Files whose names start with a dot are **dotfiles** — `ls` hides them by default, which is why you needed `-a` above.

1. Two dotfiles run automatically every time Bash starts:

```bash
cat ~/.bash_profile 2>/dev/null   # runs once, at login (e.g. when you SSH in)
cat ~/.bashrc                     # runs every time you open a new terminal
```

They set your `PATH`, your prompt, and load your aliases. After editing either one, reload it without closing the terminal:

```bash
source ~/.bashrc
```

2. Every command you type is saved to `~/.bash_history`:

```bash
history            # list everything you have run this session
history | tail     # just the most recent commands
```

Press `Ctrl-R` and start typing to reverse-search your history live. `!!` re-runs the last command; `!42` re-runs history line 42.

3. An **alias** is a short name for a longer command:

```bash
alias ll='ls -la'   # define it for this session
alias                # list every alias currently active
```

Aliases you want to keep permanently go in `~/.bash_aliases` (loaded automatically by `.bashrc`). Write down the alias definition you would add there:

```bash
echo "alias ll='ls -la'" > results/task3.txt
```

---

### 1.4 Reading File Contents

`ls` tells you a file exists. These commands show you what is inside.

1. Print an entire file to the screen:

```bash
cat treasure/README.txt
```

2. Look at just the first or last few lines — useful for huge files:

```bash
head -n 5 treasure/data.txt     # first 5 lines
tail -n 5 treasure/data.txt     # last 5 lines
```

3. `less` lets you scroll through a long file instead of dumping it all at once (`space`/`f` down, `b` up, `q` to quit):

```bash
less treasure/data.txt
```

4. `tail -f` "follows" a file as new lines are written to it — this is how you watch a live server log:

```bash
tail -f treasure/logs/access.log
# Ctrl-C to stop following
```

5. Save the first 5 lines of `data.txt`:

```bash
head -n 5 treasure/data.txt > results/task4.txt
```

6. `which` shows you where a command lives on disk — handy when `command not found` shows up unexpectedly:

```bash
which ls
```

7. Save the location of `ls`:

```bash
which ls > results/task4b.txt
```

---

## Section 2 — Finding Files

`ls` shows what is in one directory. `find` searches an entire tree. On real servers where you do not know the structure, `find` is what you actually use.

### 2.1 Search by Name

1. Look at the structure of `treasure/`:

```bash
find treasure/
```

This prints every file and directory under `treasure/`, recursively, one per line.

2. Search for a file by exact name:

```bash
find treasure/ -name "hidden.txt"
```

This searches `treasure/` and all subdirectories for any file named exactly `hidden.txt`.

3. Search using a wildcard:

```bash
find treasure/ -name "*.txt"
```

The `*` matches anything. This finds all `.txt` files anywhere under `treasure/`.

4. Search only for directories:

```bash
find treasure/ -type d
```

`-type d` filters to directories only. `-type f` would filter to files only.

5. Save the hidden file location:

```bash
find treasure/ -name "hidden.txt" > results/task5.txt
```

6. Save all directories:

```bash
find treasure/ -type d > results/task5b.txt
```

---

### 2.2 Search by Modification Time

This is something LabEx did not cover but sysadmins and developers use constantly — finding files by **when they were last changed**.

1. Find files modified in the last 60 minutes:

```bash
find treasure/ -mmin -60 -type f
```

`-mmin -60` means "modified less than 60 minutes ago". The `-` means "less than". `+60` would mean "more than 60 minutes ago".

2. Find files modified more than 1 day ago:

```bash
find treasure/ -mtime +1 -type f
```

`-mtime` counts in days. `-mtime +1` means older than 1 day. You will notice `archive/2024/old_server.conf` appears here — it was given a fake old timestamp by `init.sh`.

3. Find files changed in the last 5 minutes:

```bash
find treasure/ -mmin -5 -type f
```

This is useful for checking which log files are actively being written to on a live server.

4. Save recently modified files:

```bash
find treasure/ -mmin -60 -type f > results/task6.txt
```

---

## Section 3 — Counting and Measuring

### 3.1 Counting Lines, Words, and Characters with `wc`

`wc` stands for **word count** but it counts lines, words, and characters too.

1. Count everything in a file:

```bash
wc treasure/data.txt
```

The output shows three numbers: `lines  words  characters  filename`.

2. Count only the lines:

```bash
wc -l treasure/data.txt
```

This shows the line count and the filename: `20 treasure/data.txt`.

3. Count lines without showing the filename:

```bash
wc -l < treasure/data.txt
```

Using `<` redirects the file as input rather than passing it as an argument. The result is just `20` — no filename. This matters when you save the output for grading.

4. Count how many `.txt` files exist under `treasure/`:

```bash
find treasure/ -name "*.txt" | wc -l
```

Here `|` (the pipe) sends the output of `find` into `wc -l`. Each file path is one line, so `wc -l` counts the files.

5. Save the line count without the filename:

```bash
wc -l < treasure/data.txt > results/task7.txt
```

6. Save the count of `.txt` files:

```bash
find treasure/ -name "*.txt" | wc -l > results/task7b.txt
```

---

### 3.2 Sorting and Removing Duplicates

`sort` and `uniq` are almost always used together. `uniq` only removes **consecutive** duplicates, so you must sort first.

1. Look at the raw fruits file:

```bash
cat treasure/fruits.txt
```

You will see duplicates — `mango` and `apple` appear multiple times.

2. Sort the file alphabetically:

```bash
sort treasure/fruits.txt
```

The duplicates are now grouped together.

3. Remove the consecutive duplicates:

```bash
sort treasure/fruits.txt | uniq
```

Each fruit now appears exactly once.

4. Count how many times each fruit appears:

```bash
sort treasure/fruits.txt | uniq -c
```

`-c` prefixes each line with its count: `  4 mango`, `  3 apple`, etc.

5. Sort by count — most common first:

```bash
sort treasure/fruits.txt | uniq -c | sort -rn
```

`-r` reverses the sort (largest first). `-n` sorts numerically instead of alphabetically (so `10` comes after `9`, not after `1`).

6. Show only the most common fruit:

```bash
sort treasure/fruits.txt | uniq -c | sort -rn | head -1
```

`head -1` takes only the first line. This pattern — `sort | uniq -c | sort -rn | head -1` — gives you the most frequent item in any list. You will use it constantly in Week 4 log analysis.

7. Save the deduplicated sorted list:

```bash
sort treasure/fruits.txt | uniq > results/task8.txt
```

8. Save the most common fruit:

```bash
sort treasure/fruits.txt | uniq -c | sort -rn | head -1 > results/task8b.txt
```

---

## Section 4 — Redirecting Output

You have used `>` before. This section covers the important difference between `>` and `>>` and how to use them together.

### 4.1 Overwrite vs Append

1. Create a file with one line:

```bash
echo "first line" > results/practice.txt
cat results/practice.txt
```

`>` creates the file if it does not exist, or **completely overwrites** it if it does.

2. Add a second line without erasing the first:

```bash
echo "second line" >> results/practice.txt
cat results/practice.txt
```

`>>` **appends** to the end of the file. The first line is still there.

3. Accidentally overwrite with `>`:

```bash
echo "oops" > results/practice.txt
cat results/practice.txt
```

The file now only contains `oops`. Everything before it is gone. There is no undo in Linux.

4. Build a multi-line summary file step by step using `>>`:

```bash
echo "=== Lab Summary ===" > results/task9.txt
echo "User: $(whoami)" >> results/task9.txt
echo "Date: $(date)" >> results/task9.txt
echo "Lines in data.txt: $(wc -l < treasure/data.txt)" >> results/task9.txt
```

`$(...)` is **command substitution** — it runs the command inside and inserts the output. So `$(whoami)` is replaced by your username before `echo` runs.

5. Verify the file was built correctly:

```bash
cat results/task9.txt
```

You should see four lines: the header, your username, the current date, and the line count.

---

## Section 5 — Reading the Manual

No developer memorises every flag. The `man` command gives you the full documentation for any command, directly in the terminal — no browser needed.

### 5.1 Using `man` to Find an Unfamiliar Flag

1. Open the manual for `ls`:

```bash
man ls
```

`man` gives you the full manual. For a quicker flag summary, most commands also support `--help`:

```bash
ls --help
```

The manual opens in a pager. Use these keys to navigate:

| Key | Action |
|-----|--------|
| `Space` or `f` | scroll down one page |
| `b` | scroll up one page |
| `/` | start a search |
| `n` | jump to next search match |
| `q` | quit |

2. Search for "sort" inside the manual:

```
/sort
```

Type `/sort` and press Enter. Press `n` to jump through matches. You are looking for a flag that sorts files by **modification time**.

3. Quit the manual:

```
q
```

4. Use the flag you found to list `treasure/` sorted by modification time:

```bash
ls -t treasure/
```

`-t` sorts by modification time, newest first. The most recently changed file appears at the top.

5. Combine with `-l` to see the timestamps clearly:

```bash
ls -lt treasure/
```

6. Save the time-sorted listing:

```bash
ls -lt treasure/ > results/task10.txt
```

7. Record the flag you found so the grader can verify you used `man`:

```bash
echo "I used the flag: -t" > results/task10b.txt
```

---

## Section 6 — Pipes: Connecting Commands

The pipe `|` is the most powerful idea in Linux. It sends the output of one command as the input of the next. No temp files needed.

### 6.1 Building Pipelines

1. List all items under `treasure/`:

```bash
find treasure/
```

2. Count how many items there are:

```bash
find treasure/ | wc -l
```

The output of `find` flows directly into `wc -l`. Each path is one line, so you get a total count.

3. Chain three commands — find `.txt` files, sort them, show the first 3:

```bash
find treasure/ -name "*.txt" | sort | head -3
```

Data flows left to right: `find` produces paths → `sort` orders them → `head -3` keeps only the first three.

4. Find the largest files under `treasure/`:

```bash
find treasure/ -type f | xargs ls -l | sort -k5 -rn | head -3
```

`xargs` passes each result from `find` to `ls -l`. `sort -k5 -rn` sorts by column 5 (file size), numerically, in reverse. `head -3` keeps the top 3.

5. Save the total count of all items under `treasure/`:

```bash
find treasure/ | wc -l > results/task11.txt
```

---

## Section 7 — Challenge: Log Analysis Without a Script

This section has no step-by-step walkthrough. Most of it uses tools from Sections 1–6 — plus two new ones you'll need: `cut` (extract one column from each line) and `grep` (keep only lines matching a pattern). Full coverage of both comes next week; here's enough to get through the challenge:

```bash
# cut -d' ' -f1  → split each line on spaces, keep field 1
$ echo "192.168.1.10 GET /index.html 200" | cut -d' ' -f1
192.168.1.10

# grep "pattern"  → keep only lines containing pattern
# grep "404$"     → keep only lines ENDING in 404 (the $ anchors end-of-line)
$ printf "a 200\nb 404\n" | grep "404$"
b 404
```

The file `treasure/logs/access.log` is a web server log. Each line has the format:

```
IP_ADDRESS  METHOD  PATH  STATUS_CODE
```

For example:

```
192.168.1.10 GET /index.html 200
10.0.0.5 GET /login 404
```

Answer each question using a single pipeline. No scripts — pipes and CLI tools only.

---

**Question A — How many total requests are in the log?**

```bash
# Hint: each line is one request
<your command> > results/task12a.txt
```

---

**Question B — How many unique IP addresses made requests?**

```bash
# Hint: the IP is the first field on each line
# Hint: cut -d' ' -f1 extracts the first space-delimited field
<your command> > results/task12b.txt
```

---

**Question C — Which IP address made the most requests?**

```bash
# Hint: sort | uniq -c | sort -rn | head -1
<your command> > results/task12c.txt
```

---

**Question D — How many requests returned a 404 status code?**

```bash
# Hint: grep can match a pattern at the end of a line with $
# e.g. grep "404$" matches lines ending in 404
<your command> > results/task12d.txt
```

---

## Done?

```bash
bash check.sh    # check your score — run as many times as you want
bash submit.sh   # push to GitHub when ready
```

> If you are stuck on the challenge, re-read Section 3.2 (sort/uniq) and Section 6 (pipes). The patterns are all there.
