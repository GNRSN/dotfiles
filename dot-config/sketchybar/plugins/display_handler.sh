#!/bin/bash

source "$CONFIG_DIR/colors.sh"
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
  # background.color=$GREY

  label.width=41
  "label.font=SF Mono:Semibold:13.0"
  # label.color=$WHITE
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
    --subscribe monitor.$monitor aerospace_workspace_change
done
