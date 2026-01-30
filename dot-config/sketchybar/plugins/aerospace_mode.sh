#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Debug mode flag
DEBUG_MODE=false

CURRENT_MODE=($(aerospace list-modes --current))

if [ "$CURRENT_MODE" = "main" ] && [ "$DEBUG_MODE" != true ]; then
  LABEL=""
else
  # Capitalize first letter of mode
  LABEL=$(echo "$CURRENT_MODE" | cut -c1 | tr '[:lower:]' '[:upper:]')
fi

STYLE=(
  # Sunflower yellow
  icon.color=0xffffea00
  padding_left=10
  label.drawing=off
  icon.padding_left=0
)

sketchybar --set aerospace_mode width=25 icon=${LABEL} \
  "${STYLE[@]}"
