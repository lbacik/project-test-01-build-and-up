#!/usr/bin/env bash

DIRNAME=$(dirname "$0")
source "${DIRNAME}/../.env"

while getopts "b:v:" opt; do
    case "$opt" in
        b) BRANCH=$OPTARG
            ;;
        v) VOLUME=$OPTARG
            ;;
        *)
   esac
done

if [ -z "${BRANCH}" ]; then
    echo "ERROR! You have to specify branch."
    exit 1
fi

if [ -z "${VOLUME}" ]; then
    echo "ERROR! You have to specify volume."
    exit 2
fi

GIT_IMAGE="${DIRNAME}/../images/git"
GIT_CONTAINER='git:local'

# build git container if it doesn't exist
$DOCKER image inspect ${GIT_CONTAINER} >/dev/null 2>&1 || \
    $DOCKER build \
      --build-arg HOST="${GIT_HOST}" \
      --build-arg PORT="${GIT_PORT}" \
      -t "${GIT_CONTAINER}" "${GIT_IMAGE}"

# checkout project
$DOCKER run --rm -v "${VOLUME}:${PROJECT_DIR}" "${GIT_CONTAINER}" \
    git clone -b "${BRANCH}" "${PROJECT_GIT_URL}" "${PROJECT_DIR}"
