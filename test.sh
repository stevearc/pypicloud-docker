#!/bin/bash
set -e -o pipefail
CONTAINER=pypi-test
tag=${1-latest}

cleanup() {
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}
trap cleanup SIGINT SIGTERM EXIT

docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run --pull never -d --name "$CONTAINER" -P "stevearc/pypicloud:$tag"
sleep 5

port=$(docker inspect "$CONTAINER" | jq -r '.[0].NetworkSettings.Ports["8080/tcp"][0].HostPort')
if curl --fail "http://localhost:$port/health"; then
  echo -e "\nSuccess"
else
  echo -e "\nFailed"
  exit 1
fi
