#!/usr/bin/env bash
# Resize counterpart to smart-splits' herdr-navigate.sh, which only covers movement.
# Forwards ctrl+alt+hjkl when nvim is in the foreground so smart-splits resizes its
# own splits (and the herdr pane at an edge), otherwise resizes the herdr pane.
set -euo pipefail

dir=$1
pane=$HERDR_ACTIVE_PANE_ID

case $dir in
  left) key=ctrl+alt+h axis=width ;;
  down) key=ctrl+alt+j axis=height ;;
  up) key=ctrl+alt+k axis=height ;;
  right) key=ctrl+alt+l axis=width ;;
esac

if herdr pane process-info --pane "$pane" |
  jq -e '.result.process_info.foreground_processes[]?.name | select(test("^n?vim$"))' >/dev/null; then
  exec herdr pane send-keys "$pane" "$key"
fi

# herdr resizes by split ratio, convert to 3 cells to match smart-splits' default_amount
amount=$(herdr pane edges --pane "$pane" | jq --arg axis "$axis" '3 / .result.edges.layout.area[$axis]')

exec herdr pane resize --pane "$pane" --direction "$dir" --amount "$amount"
