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
  echo "Running tests"
  ./test.sh latest
  ./test.sh latest-alpine
  echo "Tests passed"
  docker push "stevearc/pypicloud:latest"
  docker push "stevearc/pypicloud:latest-alpine"
  if git describe --tags --exact-match; then
    docker push "stevearc/pypicloud:$tag"
    docker push "stevearc/pypicloud:$tag-alpine"
  else
    echo "Not pushing $tag because it is not an exact version"
  fi
fi
