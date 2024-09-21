#!/bin/bash

# Take the MS timestamp as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <MS timestamp>"
  exit 1
fi
timestamp=$1

# Convert the MS timestamp to seconds
seconds=$(echo "scale=0; $timestamp / 1000" | bc)

# Print the date and time in a human-readable format
date -r $seconds +"%Y-%m-%d %H:%M:%S"
