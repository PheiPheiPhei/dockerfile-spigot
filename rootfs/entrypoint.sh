#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

if [ -n "${TIMEZONE:-}" ]
then
    if [ -e "/usr/share/zoneinfo/${TIMEZONE}" ]
    then
        ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
    else
        echo "${TIMEZONE}: invalid timezone" >&2
        exit 1
    fi
fi

if [ "${EULA:-}" == "TRUE" ]
then
    echo "eula=${EULA}" > "${SERVER_ROOT}/eula.txt"
else
    echo "agreement to EULA not indicated" >&2
    exit 1
fi

if [ -n "${RESTORE_DIR:-}" ]
then
    echo "RESTORE_DIR=${RESTORE_DIR}" >> /etc/conf.d/spigot
fi

if [ -n "${BACKUP_SCHEDULE:-}" ]
then
    echo "${BACKUP_SCHEDULE} root /spigot-backup-cron.sh > /proc/1/fd/1 2>&1" > /etc/cron.d/spigot-backup
fi

printenv | grep -o '^SPIGOT_[^=]*' | while read VAR_NAME
do
    echo "${VAR_NAME#SPIGOT_}='${!VAR_NAME}'" >> /etc/conf.d/spigot
done

exec "${@}"
