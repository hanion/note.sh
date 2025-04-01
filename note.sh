#!/bin/bash
# fast note taking app

# configuration
NOTES_DIR=~/note
#NOTES_DIR="/path/to/your/notes"
QUEUE_FILE="$NOTES_DIR/todo/queue.md"
EDITOR=nvim
FILE_MANAGER="ranger" # could be [ranger, nvim, ...]


supports_color() {
	[[ -t 1 && $(command -v tput) && $(tput colors) -ge 8 ]]
}

print_colored() {
	local color_code=$1
	local message=$2
	if supports_color; then
		echo -e "\033[${color_code}m${message}\033[0m"
	else
		echo "$message"
	fi
}

print_success() { print_colored "32" "$1"; }
print_error() { print_colored "91" "$1"; }
print_job() { print_colored "96" "$1"; }

print_usage() {
	echo "Usage: $0 [OPTIONS]"
	echo
	echo "Options:"
	echo "  g         grep note name"
	echo "  f         fuzzy search note content"
	echo "  q [n=10]  list the top n queue task"
	echo "  eq|qe     edit queue list in editor"
	echo "  ec|ce     edit configuration(this bash file) in editor"
	echo "  install   install this script to /bin/note"
}

print_configure_help() {
    print_error "ERROR: Configuration required!"
    echo
    echo "Set the following variables in the script:"
    echo "  - NOTES_DIR  (directory for storing notes)"
    echo "  - QUEUE_FILE (todo queue file)"
    echo
    echo "Run './note.sh install' to install this script globally."
}


open_notes() {
	$FILE_MANAGER "$NOTES_DIR"
}

grep_note_name() {
	local file
	file=$(grep -rIl --exclude={import.sh,center.sh} --exclude-dir={.obsidian,journal} . "$NOTES_DIR" | 
		fzf --preview "bat --style=numbers --color=always --line-range=:100 {}") || return

	[[ -n "$file" ]] && $EDITOR "$file"
}

fuzzy_search_note_content() {
	local selection file line
	selection=$(grep -rnI --exclude={import.sh,center.sh} --exclude-dir={.obsidian,journal} . "$NOTES_DIR" | 
		fzf --delimiter : --nth=2.. --preview 'bat --style=numbers --color=always --highlight-line {2} {1}') || return

	file=$(cut -d: -f1 <<< "$selection")
	line=$(cut -d: -f2 <<< "$selection")

	[[ -n "$file" ]] && [[ -n "$line" ]] && $EDITOR +"$line" "$file"
}

show_queue() {
	# print the top n queue in queue file, including the title
	head -n "$(( $1 + 1 ))" "$QUEUE_FILE"
}

edit_queue_list() {
	$EDITOR "$QUEUE_FILE"
}

edit_configuration() {
	SCRIPT_FILE="$(realpath "$0")"
	$EDITOR "$SCRIPT_FILE"
}


install() {
	SCRIPT_FILE="$(realpath "$0")"

	if [[ -f "/bin/note" ]]; then
		print_error "ERROR: /bin/note already exists. Please remove it first."
		exit 1
	fi

	print_job "[CMD]: sudo mv $SCRIPT_FILE /bin/note"
	sudo mv "$SCRIPT_FILE" "/bin/note"

	print_success "Installation successful! You can now run 'note' from anywhere."
}


main() {
	if [[ "$NOTES_DIR" == "/path/to/your/notes" ]] || [[ -z "$NOTES_DIR" ]]; then
		print_configure_help
		exit 1
	fi

	if [[ $# -eq 0 ]]; then
		open_notes
		exit 0
	fi

	case "$1" in
		g)  grep_note_name ;;
		f)  fuzzy_search_note_content ;;
		q)
			queue_count="${2:-10}"
			show_queue "$queue_count"
			;;
		eq|qe) edit_queue_list ;;
		ec|ce) edit_configuration ;;
		install) install ;;

		h|-h|help|--help) print_usage ;;
		*)
			print_error "Unknown option: $1"
			print_usage
			exit 1
			;;
	esac
}


main "$@"

