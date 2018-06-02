#!/bin/bash

set -euo pipefail

source /usr/local/etc/spigot.conf

for DIRECTORY in "${SERVER_DIR}" "${BACKUP_DIR}" "${RESTORE_DIR}"
do
    mkdir -p "${DIRECTORY}"
    chown "${PUID}:${PGID}" "${DIRECTORY}"
done

if [ -n "${EULA:-}" ]
then
    echo "eula=${EULA}" > "${SERVER_DIR}/eula.txt"
fi

if [ -n "${RESTORE_BEFORE_START}" ]
then
    spigot-exec spigot-restore
fi

exec "${@}"
