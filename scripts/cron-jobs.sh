#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

write_job() {
  EXISTS=$(crontab -l | grep -q "${2}" && echo 1 || echo 0)

  if [ "$EXISTS" = "0" ]; then
    echo "Writing cron job for ${2}"
    (crontab -l 2>/dev/null; echo "${1} . $HOME/.bashrc; ${2}") | crontab -
  else
    echo "Cron job for ${2} already exists!"
  fi
}

write_job "0 8 * * *" "${CODE_DIR_SCRIPTS}/clean-logs.sh"
write_job "0 8 * * *" "${CODE_DIR_SCRIPTS}/refresh-monitor.sh"
write_job "* * * * *" "${CODE_DIR_SCRIPTS}/clean-old.sh"
write_job "*/2 * * * *" "${CODE_DIR_SCRIPTS}/space-saver.sh"
write_job "*/5 * * * *" "${CODE_DIR_SCRIPTS}/sync-enc.sh"
