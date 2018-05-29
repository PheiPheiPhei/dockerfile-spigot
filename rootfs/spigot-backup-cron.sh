#!/bin/sh

set -euo pipefail

if [ "$(/spigot-status.sh)" == 'running' ]
then
    /spigot-backup.sh
fi
