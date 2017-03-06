#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

LOG_FILE_PATH="${CODE_DIR}/enc-sync.log"
EMPTY_CHECK="${CODE_DIR}/.check"
CLEAN_SCRIPT="${CODE_DIR_SCRIPTS}/clean-old.sh"
TRANSFERS=$(cat "${LOG_FILE_PATH}" |grep -e "Transferred: " |cut -d':' -f2 |tail -n1 | tr -d '[:blank:]' |paste -s -d '');
TRANSFERS=$(echo $((TRANSFERS+0)))

echo "Tallied $TRANSFERS transfers."

if [ 0 -eq $((TRANSFERS+0)) ]; then
  COUNT=0
  if [ -f "$EMPTY_CHECK" ]; then
    COUNT=$(cat "$EMPTY_CHECK")
  fi
  if [ $((COUNT)) -gt 2 ]; then
    # echo "going to run CLEAN_SCRIPT 1"
    "$CLEAN_SCRIPT" "1"
    rm -f "$EMPTY_CHECK" 2>&1
  else
    COUNT=$((COUNT+1))
    echo "$COUNT" > "$EMPTY_CHECK"
  fi else

  rm -f "$EMPTY_CHECK" 2>&1
fi

set +e
