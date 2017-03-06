#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

USER_MUXIMUX="muximux"

cd "$CODE_DIR_SCRIPTS"
./cron-jobs.sh
./refresh-monitor.sh
cd "$CODE_DIR"
touch ./enc-sync.log
if [ ! -f "./.wait" ]; then echo "WAIT_TIME=480" > "./.wait"; else true; fi

echo "Starting up services..."
docker-compose stop &>/dev/null
docker-compose rm -f &>/dev/null
docker-compose up -d
MSG="Media management services were initialized successfully."; \
echo -e "\e[32m${MSG}\e[0m"

set +e
