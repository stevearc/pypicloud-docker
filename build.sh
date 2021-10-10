#!/bin/bash
set -e -o pipefail

./cp-static.sh
tag=$(git describe --tags)
echo "Building $tag"

docker build --pull py3-baseimage -t "stevearc/pypicloud:latest" -t "stevearc/pypicloud:$tag"
docker build --pull py3-alpine -t "stevearc/pypicloud:latest-alpine" -t "stevearc/pypicloud:$tag-alpine"

if [ "$1" == '--publish' ]; then
  if [ -n "$(git status --porcelain)" ]; then
    git status
    echo ""
    echo "Repo is not clean. Refusing to publish."
    exit 1
  fi
  git describe --tags --exact-match
  docker push "stevearc/pypicloud:latest"
  docker push "stevearc/pypicloud:$tag"
  docker push "stevearc/pypicloud:latest-alpine"
  docker push "stevearc/pypicloud:$tag-alpine"
fi
