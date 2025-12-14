#!/bin/bash

DIRS=(
  "$HOME/github"
  "$WORK_DIR"
)

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(
    {
      printf '%s\n' "$HOME/dotfiles"
      fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path
    } |
      sed "s|^$HOME/||" |
      fzf
  )
  [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
if ! tmux has-session -t "$selected_name"; then
  tmux new-session -ds "$selected_name" -c "$selected"
  tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"
