#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

SERVER_ROOT="${RESTORE_DIR:-${SERVER_ROOT}}" spigot backup
