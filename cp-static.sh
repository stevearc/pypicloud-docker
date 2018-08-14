#!/bin/bash
set -e

for py in py2 py3; do
  for base in alpine baseimage; do
    dir="${py}-${base}"
    for file in static/*; do
      if [ -f "$file" ]; then
        cp "$file" "$dir"
      elif [ -d "$file" ] && [ "$(basename "$file")" = "$base" ]; then
        cp "$file/"* "$dir"
      fi
    done
  done
done
