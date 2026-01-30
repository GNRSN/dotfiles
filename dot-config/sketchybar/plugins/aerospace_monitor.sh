#!/bin/bash

source "$CONFIG_DIR/colors.sh"

MONITOR_ID=$1

# Get the visible workspace for this monitor
WORKSPACE_ID=$(aerospace list-workspaces --monitor $MONITOR_ID --visible)

# Update the display with monitor:workspace format
sketchybar --set monitor.$MONITOR_ID label="${MONITOR_ID}:${WORKSPACE_ID}"

HIGHLIGHTED=(
  icon.color=$BLACK
  label.color=$BLACK
  background.color=$WHITE
)

NOT_HIGHLIGHTED=(
  icon.color=$WHITE
  label.color=$WHITE
  background.color=$GREY
)

# If this is the focused monitor, highlight it
FOCUSED_MONITOR=$(aerospace list-monitors --focused | cut -d'|' -f1)

# Trim any whitespace from the values
FOCUSED_MONITOR=$(echo "$FOCUSED_MONITOR" | tr -d '[:space:]')
MONITOR_ID=$(echo "$MONITOR_ID" | tr -d '[:space:]')

if [ "$MONITOR_ID" = "$FOCUSED_MONITOR" ]; then
  sketchybar --animate quadratic 6 --set monitor.$MONITOR_ID \
    "${HIGHLIGHTED[@]}"
else
  sketchybar --animate quadratic 6 --set monitor.$MONITOR_ID \
    "${NOT_HIGHLIGHTED[@]}"
fi
