#!/usr/bin/env bash

# Thanks: https://github.com/Aider-AI/aider/issues/2156#issuecomment-2439919513

pane_dir=$(tmux display-message -p '#{pane_current_path}')
pane_id=$(tmux display-message -p '#{pane_id}')
cd "$pane_dir" || exit
git_root=$(git rev-parse --show-toplevel)

# gnu coreutils realpath is needed to make the paths relative to the currently active
# tmux pane relative to the git repo root, because aider always wants paths relative
# to the repo root, even if you are in a subdirectory
if [[ "$OSTYPE" == "darwin"* ]]; then
	if ! command -v grealpath >/dev/null 2>&1; then
		echo "grealpath not found. Install with: brew install coreutils" >&2
		exit 1
	fi
	realpath_cmd="grealpath"
else
	realpath_cmd="realpath"
fi

selected_files=$(
	fd --type f |
		fzf --multi \
			--reverse \
			--preview 'bat --style=numbers --color=always {}' |
		while read -r file; do
			"$realpath_cmd" --relative-to="$git_root" "$pane_dir/$file"
		done
)

if [ -n "$selected_files" ]; then
	files_oneline=$(echo "$selected_files" | tr '\n' ' ' | sed 's/ $//')
	tmux send-keys -t "$pane_id" "$files_oneline"
fi
