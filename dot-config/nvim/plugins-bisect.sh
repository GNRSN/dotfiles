#!/usr/bin/env bash

set -euo pipefail

LOCKFILE="$HOME/.config/nvim/lazy-lock.json"
OUTFILE="$HOME/.config/nvim/lua/plugins/disabled.lua"

mkdir -p "$(dirname "$OUTFILE")"

{
  echo "return {"

  jq -r '
    keys
    | sort
    | .[]
    | "  { \"" + . + "\", enabled = false },"
  ' "$LOCKFILE"

  echo "}"
} >"$OUTFILE"
