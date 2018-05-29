#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

# set default value not in /etc/conf.d/spigot
RESTORE_DIR="${RESTORE_DIR:-}"
BACKUP_AFTER_STOP="${BACKUP_AFTER_STOP:-}"
LIVENESS_INTERVAL_TIME="${LIVENESS_INTERVAL_TIME:-30}"

function exit_gracefully() {
    spigot stop
    [ -n "${BACKUP_AFTER_STOP}" ] && /spigot-backup.sh
}

[ -n "${RESTORE_DIR}" ] && /spigot-restore.sh

trap exit_gracefully EXIT

spigot start

while true
do
    case "$(/spigot-status.sh)" in
        running|idling)
            sleep "${LIVENESS_INTERVAL_TIME}"
            ;;
        *)
            break
            ;;
    esac
done
