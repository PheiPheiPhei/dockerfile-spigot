#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

# set default value not in /etc/conf.d/spigot
BACKUP_AFTER_STOP="${BACKUP_AFTER_STOP:-}"
RESTORE_BEFORE_START="${RESTORE_BEFORE_START:-}"
LIVENESS_INTERVAL_TIME="${LIVENESS_INTERVAL_TIME:-30}"

function is_running_or_idle() {
    spigot status | grep 'running'
}

function is_restored() {
    IS_RESTORED=1

    for BACKUP_PATH in ${BACKUP_PATHS} # space separated
    do
        if [ -d "${SERVER_ROOT}/${BACKUP_PATH}" ]
        then
            IS_RESTORED=0

            echo "${SERVER_ROOT}/${BACKUP_PATH}: Found" >&2
        else
            echo "${SERVER_ROOT}/${BACKUP_PATH}: Not found" >&2
        fi
    done

    return ${IS_RESTORED}
}

function last_backup() {
    [ -e "${BACKUP_DEST}" ] || return 0
    ls -1 "${BACKUP_DEST}"/[0-9_.]*.tar.gz | sort | tail -n1
}

function exit_gracefully() {
    spigot stop

    if [ -n "${BACKUP_AFTER_STOP}" ]
    then
        spigot backup
    fi
}

if [ -n "${RESTORE_BEFORE_START}" ]
then
    if ! is_restored
    then
        LAST_BACKUP="$(last_backup)"

        if [ -n "${LAST_BACKUP}" ]
        then
            spigot restore "${LAST_BACKUP}"
        else
            echo "No backup" >&2
        fi
    else
        echo "Skip to restore" >&2
    fi
fi

trap exit_gracefully EXIT

spigot start

while is_running_or_idle > /dev/null
do
    sleep "${LIVENESS_INTERVAL_TIME}"
done
