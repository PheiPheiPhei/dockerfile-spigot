#!/bin/sh

set -euo pipefail

source /etc/conf.d/spigot

function as_game_user() {
    if [ "$(whoami)" == "${GAME_USER}" ]
    then
        "${@}"
    else
        sudo -u "${GAME_USER}" "${@}"
    fi
}

IDLE_SESSION_NAME="${IDLE_SESSION_NAME:-idle_server_${SESSION_NAME}}"

if as_game_user screen -S "${SESSION_NAME}" -Q select . > /dev/null
then
    echo "running"
    exit 0
fi

if [ "${IDLE_SERVER,,}" == "true" ]
then
    if as_game_user screen -S "${IDLE_SESSION_NAME}" -Q select . > /dev/null
    then
        echo "idling"
        exit 0
    fi
fi

echo "stopped"
exit 0
