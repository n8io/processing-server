#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

RM_BIN="/bin/rm"
TEE_BIN="/usr/bin/tee"

LOGS_DIR="${CODE_DIR}/logs"
LOG_FILE_PATH="${CODE_DIR}/clean.log"
WAIT_CONFIG="${CODE_DIR}/.wait"
WAIT_PERIOD="+240"

if [ -f "$WAIT_CONFIG" ]; then
  source "$WAIT_CONFIG"
fi

if [ -z "$1" ]; then
  if [ ! -z "$WAIT_TIME" ]; then
    WAIT_PERIOD="+${WAIT_TIME}";
  fi
else
  WAIT_PERIOD="+${1}"
fi

echo -e "LOG_FILE_PATH=${LOG_FILE_PATH}\nWAIT_PERIOD=${WAIT_PERIOD}"

find "${LOGS_DIR}" -maxdepth 1 -type f -name "file.*" -mmin $WAIT_PERIOD -print | while
read FILE
do
  PATH=$(< "$FILE");
  if [ -f "$PATH" ]; then
    echo "Deleting ${PATH} ..." >> "$LOG_FILE_PATH"
    "$RM_BIN" -f "$PATH"
  else
    echo "Not a file ${PATH} ?" >> "$LOG_FILE_PATH"
  fi

  "$RM_BIN" -f "$FILE"
done

find "${DEC_DIR_LOCAL}" -type d -regex ".*\(adult\|kids\|release\|prerelease\)/.*" -empty -delete;

set +e
