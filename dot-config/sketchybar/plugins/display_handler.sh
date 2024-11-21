#!/bin/bash

PLUGINS_DIR="$CONFIG_DIR/plugins"

# Debug mode flag
DEBUG_MODE=false

# Get monitors list based on mode
if [ "$DEBUG_MODE" = true ]; then
  MONITORS=("1" "2" "3")
else
  MONITORS=($(aerospace list-monitors | cut -d'|' -f1))
fi

# Remove all existing monitor items
for item in $(sketchybar --query bar | jq -r '.items[] | select(.|test("^monitor\\.*"))'); do
  sketchybar --remove $item
done

MONITOR_DEFAULTS=(

  padding_left=3
  padding_right=3

  background.corner_radius=5
  background.height=20
  background.drawing=on

  label.width=41
  "label.font=SF Mono:Semibold:13.0"
  label.padding_left=8
  label.padding_right=8

  icon.padding_left=0
  icon.padding_right=0
)

# Add items for each monitor
for monitor in "${MONITORS[@]}"; do
  sketchybar --add item monitor.$monitor left \
    --set monitor.$monitor "${MONITOR_DEFAULTS[@]}" \
    script="$PLUGINS_DIR/aerospace_monitor.sh $monitor" \
    --move monitor.$monitor before front_app \
    --subscribe monitor.$monitor aerospace_workspace_change refresh_workspaces
done

# aerospace_monitor.sh doesn't run until aerospace_workspace_change is triggered
# is there something I'm missing or does the initial --update just not trigger "nested" scripts?
sketchybar --trigger refresh_workspaces
