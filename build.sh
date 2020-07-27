#!/bin/bash
set -e

# Helper for building the images locally

branch="$1"
if [ -z "$branch" ]; then
  branch="$(git branch --no-color | grep \* | cut -d ' ' -f2)"
fi
./cp-static.sh

for base in alpine baseimage; do
  cd "py3-$base"
  docker build . -t "stevearc/pypicloud:$branch-py3-$base" -t "stevearc/pypicloud:local-py3-$base"
  cd ..
done
