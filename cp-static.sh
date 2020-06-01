#!/bin/bash
set -e

for base in alpine baseimage; do
  dir="py3-${base}"
  for file in static/*; do
    if [ -f "$file" ]; then
      cp "$file" "$dir"
    elif [ -d "$file" ] && [ "$(basename "$file")" = "$base" ]; then
      cp "$file/"* "$dir"
    fi
  done
done
