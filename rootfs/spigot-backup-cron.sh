#!/bin/sh

set -euo pipefail

function is_running() {
    spigot status | grep '^Status:.*running.*'
}

if is_running > /dev/null
then
    /spigot-backup.sh
fi
