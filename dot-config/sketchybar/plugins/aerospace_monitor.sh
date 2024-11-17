#!/bin/bash

source "$CONFIG_DIR/colors.sh"

MONITOR_ID=$1

# Get the visible workspace for this monitor
WORKSPACE_ID=$(aerospace list-workspaces --monitor $MONITOR_ID --visible)

# Update the display with monitor:workspace format
sketchybar --set monitor.$MONITOR_ID label="${MONITOR_ID}:${WORKSPACE_ID}"

highlighted=(
  padding_left=5
  padding_right=5
  icon.color=$BLACK
  label.color=$BLACK
  background.color=$WHITE
  label.padding_left=8
  label.padding_right=8
  # We don't have an icon yet
  icon.padding_left=0
  icon.padding_right=0
)
sketchybar --default

# If this is the focused monitor, highlight it
FOCUSED_MONITOR=$(aerospace list-monitors --focused | cut -d'|' -f1)
if [ "$MONITOR_ID" = "$FOCUSED_MONITOR" ]; then
  sketchybar --set monitor.$MONITOR_ID \
    background.drawing=on \
    background.color=$WHITE
else
  sketchybar --set monitor.$MONITOR_ID \
    "${highlighted[@]}"
fi
