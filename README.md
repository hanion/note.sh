# note - fast note taking

**note** is a simple, command-line note-taking app designed for quick access and management.
If you don’t want to wait multiple seconds for a note-taking app to open, this is the app for you.
It lets you fuzzy search notes by name or content and manage queue tasks.


## features

- **search notes by name** using `g`
- **fuzzy search note content** using `f`
- **show a list of top queue tasks** with `q`
- **edit queue list** with `eq` or `qe`
- **edit configuration(this bash script)** with `ec` or `ce`
- **install the script to /bin/note** with `install`


## tools used

- fzf: for fuzzy searching
- bat: for file preview with syntax highlighting
- grep: for searching text in files
- head: for displaying the top queue tasks
- tput: for colored output


## installation

1. **clone the repository:**

```bash
git clone https://github.com/hanion/note.sh.git
cd note.sh
```

2. **configure the script:**

edit the script and set `NOTES_DIR`

3. **make the script executable and move it to your system path:**

```bash
chmod +x note.sh
./note.sh install
```

## usage

```
Usage: note [OPTIONS]

Options:
g         grep note name
f         fuzzy search note content
q [n=10]  list the top n queue task
eq|qe     edit queue list in editor
ec|ce     edit configuration(this bash file) in editor
```

## configuration

```bash
NOTES_DIR="/path/to/your/notes"
QUEUE_FILE="/path/to/queue.md"
EDITOR="nvim"
FILE_MANAGER="ranger" # could be [ranger, nvim, ...]
```

