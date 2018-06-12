#!/bin/bash
set -e

# Helper for building the images locally

branch="$(git branch --no-color | grep \* | cut -d ' ' -f2)"
./cp-static.sh

for py in py2 py3; do
  for base in alpine baseimage; do
    cd "$py-$base"
    docker build . -t "stevearc/pypicloud:$branch-$py-$base"
    cd ..
  done
done
