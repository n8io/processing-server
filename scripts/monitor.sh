#!/bin/sh
#!/
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

LOG_FILE_PATH="${CODE_DIR}/enc-creates.log"
LOGS_DIR="${CODE_DIR}/logs"
mkdir -p "$LOGS_DIR"
echo "Started watch..." > "$LOG_FILE_PATH"
inotifywait -m -r -e create,move --format '%w%f' "${DEC_DIR_LOCAL}" | while
read FILE
do
  if [ -f "$FILE" ]; then
    TMP_FILE=$(mktemp "${LOGS_DIR}/file.XXXXXXXXXX")
    echo "${FILE} : ${TMP_FILE}" >> "$LOG_FILE_PATH"
    echo "$FILE" > "$TMP_FILE"
  fi
done

set +e
