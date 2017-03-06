#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

DOCKER_COMPOSE_BIN="/usr/local/bin/docker-compose"
OUTPUT_FILE="${CODE_DIR}/last-cycle-docker.log"
NOW=$(date "+%Y-%m-%d %r")
cd "$CODE_DIR" || exit 1
echo "Process started @ $NOW" > "$OUTPUT_FILE"
"$DOCKER_COMPOSE_BIN" stop >> "$OUTPUT_FILE" 2>&1
"$DOCKER_COMPOSE_BIN" rm -f >> "$OUTPUT_FILE" 2>&1
"$DOCKER_COMPOSE_BIN" up -d >> "$OUTPUT_FILE" 2>&1
NOW=$(date "+%Y-%m-%d %r")
echo "Process ended @ $NOW" >> "$OUTPUT_FILE"

set +e
