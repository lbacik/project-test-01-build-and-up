#!/usr/bin/env bash

DIRNAME=$(dirname "$0")
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

#if [[ ! "${BRANCH}" =~ ^[0-9a-z-]+$ ]]; then
#    echo "ERROR! Branch name can contain only lower characters, numbers and hyphens"
#    exit 2
#fi

#VOLUME="checkout-${PROJECT_NAME}-${BRANCH}"

#"${DIRNAME}/bin/checkout.sh" -b "${BRANCH}" -v "${VOLUME}" || exit 2

#---

# opcja alternatywna
# dind
# config przy up (?)


#DOCKER_BUILDER="${DOCKER}" run --rm \
#    -v "${DOCKER_SOCKET}:/var/run/docker.sock" \
#    -v "${VOLUME}:${PROJECT_DIR}" \
#    "lbacik/docker-image-builder docker-image-builder"

#$DOCKER_BUILDER \
#    --images-name-prefix "build-${PROJECT_NAME}-${BRANCH}" \
#    --final-image-name "${PROJECT_NAME}:${BRANCH}" \
#    --remove-builds \
#    ${PROJECT_DIR}

####    ${DOCKER_DIR_INSIDE_CONTAINER}/image/build-dev \
####        ARG:BRANCH="${BRANCH}"

${DOCKER} build -t ${PROJECT_NAME}:${BRANCH} ${PROJECT_GIT_URL}#${BRANCH}

