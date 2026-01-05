#!/usr/bin/env bash

# LATER: Maybe it would suffice to only add plugins with a diff in the lockfile?
# but should also take an --all flag to disable all

set -euo pipefail

LOCKFILE="$HOME/.config/nvim/lazy-lock.json"
OUTFILE="$HOME/.config/nvim/lua/plugins/disabled.lua"

mkdir -p "$(dirname "$OUTFILE")"

{
  echo "-- Easily delete this file through git when bisect is completed
  return {"

  jq -r '
    keys
    | sort
    | .[]
    | "  { \"" + . + "\", enabled = false },"
  ' "$LOCKFILE"

  echo "}"
} >"$OUTFILE"

nvim $OUTFILE
