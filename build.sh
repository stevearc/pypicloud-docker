#!/bin/bash
set -e -o pipefail

./cp-static.sh
tag=$(git describe --tags)
platforms=${BUILDX_PLATFORMS:-linux/amd64}
alias buildx_build="docker buildx build --platform=${platforms}"
echo "Building ${tag} for platforms ${platforms}"

buildx_build --pull py3-baseimage -t "stevearc/pypicloud:latest"
buildx_build --pull py3-alpine -t "stevearc/pypicloud:latest-alpine"

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
  buildx_build --push py3-baseimage -t "stevearc/pypicloud:latest"
  buildx_build --push py3-alpine -t "stevearc/pypicloud:latest-alpine"
  if git describe --tags --exact-match; then
    buildx_build --push py3-baseimage -t "stevearc/pypicloud:$tag"
    buildx_build --push py3-alpine -t "stevearc/pypicloud:$tag-alpine"
  else
    echo "Not pushing $tag because it is not an exact version"
  fi
fi
