#!/usr/bin/env bash

DIRNAME=`dirname "$0"`
source ${DIRNAME}/.env

DOCKER=docker

while getopts "b:mprt" opt; do
    case "$opt" in
        b) BRANCH=$OPTARG
            ;;
        m) MYSQL=1
            ;;
        p) PMA=1
            ;;
        r) REDIS=1
            ;;
        t) PROJECT=1
            ;;
    esac
done

if [ -z "${BRANCH}" ]; then
    echo "You have to specify branch!"
    exit 1
fi

[[ $MYSQL == 1 ]] && \
    $DOCKER run --rm -d \
        --net "${NETWORK_NAME}" \
        --name "${BRANCH}-mysql" \
        --net-alias "${BRANCH}.mysql.${DOMAIN}" \
        -e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
        -e MYSQL_DATABASE="${PROJECT_NAME}" \
        -v "${MYSQL_BACKUPS}:/docker-entrypoint-initdb.d/:ro" \
        --health-cmd='mysqladmin ping --silent' \
        --health-interval=2s \
        mariadb:10.1 \
        mysqld \
          --character-set-server=utf8mb4 \
          --collation-server=utf8mb4_unicode_ci \
          --innodb-file-format=Barracuda \
          --innodb-large-prefix=1 \
          --innodb-file-per-table=1

[[ $PMA == 1 ]] && \
    $DOCKER run --rm -d \
        --net "${NETWORK_NAME}" \
        --name "${BRANCH}-pma" \
        --net-alias "${BRANCH}.pma.proxy.${DOMAIN}" \
        -e PMA_HOST="${BRANCH}.mysql.${DOMAIN}" \
        -e VIRTUAL_HOST="${BRANCH}.pma.proxy.${DOMAIN}" \
        phpmyadmin/phpmyadmin


[[ $REDIS == 1 ]] && \
    $DOCKER run --rm -d \
        --net "${NETWORK_NAME}" \
        --name "${BRANCH}-redis" \
        redis

[[ $PROJECT == 1 ]] && \
    $DOCKER run --rm -d \
        --net "${NETWORK_NAME}" \
        --name "${BRANCH}-${PROJECT_NAME}" \
        --net-alias "${BRANCH}.proxy.${DOMAIN}" \
        -e VIRTUAL_HOST="${BRANCH}.proxy.${DOMAIN}" \
        ${PROJECT_NAME}:${BRANCH}

