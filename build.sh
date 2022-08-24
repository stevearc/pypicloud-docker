#!/bin/bash
set -e -o pipefail

usage="$0 -i <image> [options]
  -i <image>    \"baseimage\" or \"alpine\"
  -p <platform> Build images for this platform(s)
  --test        Run tests after build
  --publish     Run tests and push images after build
"
while getopts "h-:i:p:" opt; do
  case $opt in
    -)
      case $OPTARG in
        test)
          TEST=1
          ;;
        publish)
          TEST=1
          PUBLISH=1
          ;;
        *)
          echo "$usage"
          exit 1
          ;;
      esac
      ;;
    i)
      IMAGE="$OPTARG"
      ;;
    p)
      PLATFORM="$OPTARG"
      ;;
    h)
      echo "$usage"
      exit 0
      ;;
    \?)
      echo "$usage"
      exit 1
      ;;
  esac
done
if [ -z "$IMAGE" ]; then
  echo "$usage"
  exit 1
fi
shift $((OPTIND - 1))

tag=$(git describe --tags || echo "latest")
platforms="${PLATFORM:-linux/amd64}"
echo "Building ${tag} for platforms ${platforms}"
set -x
./cp-static.sh

case $IMAGE in
  baseimage)
    suffix=""
    ;;
  alpine)
    suffix="-$IMAGE"
    ;;
  *)
    echo "Unrecognized image $IMAGE"
    exit 1
    ;;
esac
docker buildx build "--platform=${platforms}" --pull "py3-$IMAGE" -t "stevearc/pypicloud:latest${suffix}"

if [ $TEST ]; then
  echo "Build and load single-platform image for test"
  if [[ $platforms =~ , ]]; then
    docker buildx build "--platform=linux/amd64" "py3-$IMAGE" --load -t "stevearc/pypicloud:latest${suffix}"
  else
    docker buildx build "--platform=${platforms}" "py3-$IMAGE" --load -t "stevearc/pypicloud:latest${suffix}"
  fi
  echo "Running tests"
  ./test.sh "latest$suffix"
  echo "Tests passed"
fi

if [ $PUBLISH ]; then
  if [ -n "$(git status --porcelain)" ]; then
    git status
    echo ""
    echo "Repo is not clean. Refusing to publish."
    exit 1
  fi
  docker buildx build "--platform=${platforms}" --push "py3-$IMAGE" -t "stevearc/pypicloud:latest$suffix"
  if git describe --tags --exact-match; then
    docker buildx build "--platform=${platforms}" --push "py3-$IMAGE" -t "stevearc/pypicloud:${tag}${suffix}"
  else
    echo "Not pushing $tag because it is not an exact version"
  fi
fi
