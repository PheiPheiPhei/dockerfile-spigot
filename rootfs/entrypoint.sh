#!/bin/bash

set -euo pipefail

source /usr/local/etc/event.conf
source /usr/local/etc/spigot.conf

DIRECTORIES=(
    "${SERVER_DIR}"
    "${BACKUP_DIR}"
    "${RESTORE_DIR}"
    "${EVENT_ROOT}"
)

FIFOS=(
    "${EVENT_BUS}"
    "${EVENT_ROOT}/${SERVICE_BACKUP_CONTROLLER}"
    "${EVENT_ROOT}/${SERVICE_LIST_CONTROLLER}"
    "${EVENT_ROOT}/${SERVICE_STOP_CONTROLLER}"
)

for DIRECTORY in "${DIRECTORIES[@]}"
do
    mkdir -p "${DIRECTORY}"
    chown "${PUID}:${PGID}" "${DIRECTORY}"
done

for FIFO in "${FIFOS[@]}"
do
    mkfifo -m 600 "${FIFO}"
    chown "${PUID}:${PGID}" "${FIFO}"
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
