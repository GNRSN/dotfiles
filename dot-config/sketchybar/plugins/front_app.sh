#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi

# Show the "(floating)" suffix item when the focused window floats in Aerospace
if [ "$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)" = "floating" ]; then
  sketchybar --set front_app_floating drawing=on
else
  sketchybar --set front_app_floating drawing=off
fi
