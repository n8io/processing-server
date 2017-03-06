#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

screen -ls | grep ".monitor" | cut -d. -f1 | awk '{print $1}' | xargs kill &>/dev/null || true
screen -S monitor -dm "${CODE_DIR_SCRIPTS}/monitor.sh"

set +e
