#!/usr/bin/env bash
# Uninstall Homebrew packages that aren't declared in the nix-darwin Brewfile.
#
# Replaces homebrew.onActivation.cleanup, since `brew bundle cleanup` treats
# formula dependencies of casks (e.g. gcloud-cli's python) as undeclared.
# Only formulae installed on request are candidates, orphaned dependencies are
# left to `brew autoremove` which does account for casks.
#
# Runs automatically after `darwin-rebuild switch` (see modules/darwin.nix).
# Usage: brew-cleanup.sh <Brewfile> [--dry-run]
set -euo pipefail

BREWFILE="$1"
DRY_RUN="${2:-}"

export PATH="/opt/homebrew/bin:$PATH"
# Same tap trust workaround as log-packages.sh
export XDG_CONFIG_HOME="$HOME/.config"
export HOMEBREW_NO_AUTO_UPDATE=1
export LC_ALL=C

lower() { tr '[:upper:]' '[:lower:]' | sort -u; }
# Entries are `brew "<name>"` / `cask "<name>"`, tap names are case-insensitive
declared() { sed -nE "s/^$1 \"([^\"]+)\".*/\1/p" "$BREWFILE" | lower; }
undeclared() { comm -23 <(lower) <(declared "$1"); }

formulae=$(brew leaves --installed-on-request | undeclared brew)
casks=$(brew list --cask --full-name | undeclared cask)

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  echo "Undeclared formulae: ${formulae:-none}"
  echo "Undeclared casks: ${casks:-none}"
  brew autoremove --dry-run
  exit
fi

# Word splitting is intended, names never contain whitespace.
# Don't abort activation if brew refuses, e.g. a cask still depends on a formula
if [[ -n "$formulae" ]]; then
  # shellcheck disable=SC2086
  brew uninstall --formula $formulae || true
fi
if [[ -n "$casks" ]]; then
  # shellcheck disable=SC2086
  brew uninstall --cask $casks || true
fi
brew autoremove
