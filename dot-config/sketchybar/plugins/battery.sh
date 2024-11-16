#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Override battery level for testing (comment out for normal operation)
# BATTERY_OVERRIDE=50

# Get battery percentage, either from override or system
if [ -n "$BATTERY_OVERRIDE" ]; then
  PERCENTAGE=$BATTERY_OVERRIDE
else
  PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
fi

CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Default color (white)
COLOR="0xffffffff"

# Set icon based on charging status
if [ -n "$CHARGING" ]; then
  ICON="􀢋" # Charging icon
else
  ICON="􀺶" # Battery icon

  # Set color based on battery level
  if [ "$PERCENTAGE" -le 10 ]; then
    COLOR="0xffff0000" # Red
  elif [ "$PERCENTAGE" -le 30 ]; then
    COLOR="0xffffd700" # Yellow
  fi
fi

# Only show icon if battery is <= 30%
if [ "$PERCENTAGE" -le 30 ]; then
  sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label=""
else
  sketchybar --set "$NAME" icon="" label=""
fi
