#!/usr/bin/env bash

set -euo pipefail

# Are we inside a git repo?
if ! git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
  echo "Not inside a git repository"
  exit 1
fi

# Resolve the actual .git dir (handles worktrees / submodules)
git_dir=$(git rev-parse --git-dir)

# If git-dir is relative, resolve it against the repo root
if [[ "$git_dir" != /* ]]; then
  git_dir="$git_root/$git_dir"
fi

# If Graphite metadata exists → use Graphite config
if [[ -d "$git_dir/.gt" ]]; then
  # Set pane title
  echo -n -e "\033]0;Lazygit (graphite)\007"

  exec lazygit \
    --use-config-file \
    "$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/graphite.yml"
else
  # Set pane title
  echo -n -e "\033]0;Lazygit\007"

  exec lazygit
fi
