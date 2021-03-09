#!/usr/bin/env bash

DIRNAME=$(dirname "$0")
# shellcheck disable=SC1090
source "${DIRNAME}/.env"

while getopts "b:" opt; do
    case "$opt" in
        b) BRANCH=$OPTARG
            ;;
        *)
   esac
done

if [ -z "${BRANCH}" ]; then
    echo "ERROR! You have to specify branch."
    exit 1
fi

${DOCKER} build -t "${PROJECT_NAME}:${BRANCH}" "${PROJECT_GIT_URL}#${BRANCH}"
