#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

# set default value not in /etc/conf.d/spigot
LATEST_LOG_PATH="${LATEST_LOG_PATH:-logs/latest.log}"

tail -F "${SERVER_ROOT}/${LATEST_LOG_PATH}"
