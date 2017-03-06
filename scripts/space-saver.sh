#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

SABNZBD_API_KEY="$(cat "${CODE_DIR}/configs/sabnzbd/sabnzbd.ini" | grep -e "^api_key = " | tail -n 1 | awk '{print $3}')"
MIN_SPACE_THRESHOLD=5120000
AUTO_PAUSE="${CODE_DIR}/.auto-pause"
FREE_SPACE=$(df -T "$BIG_DRIVE_MOUNT" | tail -1 | awk '{print $5}')
FREE_MSG="There is $(df -hT "$BIG_DRIVE_MOUNT" | tail -1 | awk '{print $5}') free"

if [ $FREE_SPACE -lt $MIN_SPACE_THRESHOLD ]; then
  if [ ! -f "$AUTO_PAUSE" ]; then
    curl -sS http://localhost:8080/sabnzbd/api -F apikey=${SABNZBD_API_KEY} -F mode=pause >/dev/null
    echo "Sabnzbd paused"
    docker exec mediaserverconfig_transmission_1 transmission-remote --auth ${UMS_USER}:${UMS_PASS} --torrent all --stop >/dev/null
    echo "Transmission paused"
    echo "$(date)" > "$AUTO_PAUSE"
  else
    echo "No action taken. Sabnzbd and Transmission already paused."
  fi
elif [ -f "$AUTO_PAUSE" ]; then
  curl -sS http://localhost:8080/sabnzbd/api -F apikey=${SABNZBD_API_KEY} -F mode=resume >/dev/null
  echo "Sabnzbd resumed"
  docker exec processingserver_transmission_1 transmission-remote --auth "${UMS_USER}:${UMS_PASS}" --torrent all --start >/dev/null
  echo "Transmission resumed"
  rm -f "$AUTO_PAUSE"
else
  echo "No action taken"
fi

echo $FREE_MSG

set +e
