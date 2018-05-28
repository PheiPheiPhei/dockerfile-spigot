#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

function restore_capability() {
    RESTORE_CAPABILITY=0

    for BACKUP_PATH in ${BACKUP_PATHS} # space separated
    do
        if [ -e "${SERVER_ROOT}/${BACKUP_PATH}" ]
        then
            if [ -l "${SERVER_ROOT}/${BACKUP_PATH}" ]
            then
                echo "${SERVER_ROOT}/${BACKUP_PATH}: PASS (Symbolic link)" >&2
            else
                RESTORE_CAPABILITY=1
                echo "${SERVER_ROOT}/${BACKUP_PATH}: N/A (File or directory)" >&2
            fi
        else
            echo "${SERVER_ROOT}/${BACKUP_PATH}: PASS (Not exist)" >&2
        fi
    done

    return ${RESTORE_CAPABILITY}
}

function last_backup() {
    ls -1 "${BACKUP_DEST}"/[0-9_.]*.tar.gz 2> /dev/null | tail -n1
}

echo "${RESTORE_DIR}: Preparing..." >&2
mkdir -p "${RESTORE_DIR}"
rm -rf "${RESTORE_DIR}"/*
echo "${RESTORE_DIR}: Prepared" >&2

if ! restore_capability
then
    echo "Skip to restore" >&2
    exit 0
fi

if ! LAST_BACKUP="$(last_backup)"
then
    echo "No backup" >&2
    exit 0
fi

SERVER_ROOT="${RESTORE_DIR}" spigot restore "${LAST_BACKUP}"

for BACKUP_PATH in ${BACKUP_PATHS} # space separated
do
    ln \
    --force \
    --no-dereference \
    --symbolic \
    "${RESTORE_DIR}/${BACKUP_PATH}" "${SERVER_ROOT}/${BACKUP_PATH}"
done
