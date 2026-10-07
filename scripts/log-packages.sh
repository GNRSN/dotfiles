#!/usr/bin/env bash
# Log the exact versions of everything installed through nix-darwin and homebrew
# to packages.txt and brew.txt so upgrades show up in git history.
#
# Runs automatically after `darwin-rebuild switch` (see modules/darwin.nix),
# which means it runs from a root activation script with a scrubbed environment.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# During activation /run/current-system still points at the previous generation,
# so the hook passes the one being activated explicitly
SYSTEM="${1:-/run/current-system}"

export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:$PATH"
# Brew reads tap trust from $XDG_CONFIG_HOME/homebrew/trust.json, without it
# tapped formulae are considered untrusted and silently dropped from the dump
export XDG_CONFIG_HOME="$HOME/.config"
# Deterministic sort order regardless of the caller's locale
export LC_ALL=C

# Entries in the system profile that aren't packages we manage, as regexes
EXCLUDE=(
  '.*-man'
  '.*-info'
  'darwin-.*'
  'bash-interactive-.*'
  'texinfo-interactive-.*'
  'nix-info'
  'nix-zsh-completions-.*'
)

# Global npm packages are managed through mise/corepack, not brew
brew bundle dump --force --no-npm --no-vscode --file="$REPO/brew.txt"

# $SYSTEM/sw links to the merged profile of environment.systemPackages,
# resolve it since nix-store otherwise queries the generation it sits in.
# its direct references are the packages themselves as <hash>-<name>-<version>
nix-store --query --references "$(readlink -f "$SYSTEM/sw")" \
  | sed -E 's|^/nix/store/[a-z0-9]{32}-||' \
  | grep -vE "^($(IFS='|'; echo "${EXCLUDE[*]}"))$" \
  | sort -uf \
  > "$REPO/packages.txt"
