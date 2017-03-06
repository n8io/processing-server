#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

PIDFILE="${CODE_DIR}/sync-enc.pid"
LOG_FILE="${CODE_DIR}/enc-sync.log"
EMPTY_CHECK_SCRIPT="${CODE_DIR_SCRIPTS}/empty-check.sh"
RCLONE_REMOTE_NAME="$([ ! -z "$RCLONE_REMOTE_NAME" ] && echo "$RCLONE_REMOTE_NAME" || "$RCLONE_BIN" listremotes | head -n 1 | sed -e 's/\(:\)*$//g')"

if [ -f $PIDFILE ]; then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Process already running"
    exit 1
  else
    ## Process not found assume not running
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]; then
      echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]; then
    echo "Could not create PID file"
    exit 1
  fi
fi

"${RCLONE_BIN}" copy "${ENC_DIR_LOCAL}" "${RCLONE_REMOTE_NAME}:${ENC_DIR_REMOTE}/" --size-only --transfers 10 --stats 15s &> "${LOG_FILE}"

rm $PIDFILE

"$EMPTY_CHECK_SCRIPT"

set +e
