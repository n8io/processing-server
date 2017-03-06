#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
BASHRC="/root/.bashrc"
ENV_FILE="${CODE_DIR}/.env"

PREV_REMOTE_DIR="${ENC_DIR_REMOTE:-/encrypted}"
PREV_MOUNT_DIR="${MOUNT_DIR:-/mnt/x}"
PREV_ENCFS_CREDS="${ENCFS_CREDS:-/.encfs}"
PREV_ENCFS6_CONFIG="${ENCFS6_CONFIG:-/encfs.xml}"
PREV_CODE_DIR="${CODE_DIR:-/processing-server}"
PREV_RCLONE_CONFIG="${RCLONE_CONFIG:-/root/.rclone.conf}"
PREV_PIA_USER="${PIA_USER}"
PREV_PIA_PASS="${PIA_PASS}"

wipe_old() {
  sed -i '/[#]processing[-]server[-]start/,/[#]processing[-]server[-]end/ d' "$BASHRC"
}

prompt_for_creds() {
  echo -n "Enter your Amazon Cloud Drive encrypted directory [${PREV_REMOTE_DIR}]: "
  read ENC_DIR_ACD

  if [ ! -z "$PIA_USER" ] && [ ! -z "$PIA_PASS" ]; then
    echo -n "Would you like to [o]verwrite or [R]euse the existing PIA credentials [oR]? "
    read OVERWRITE_PIA

    if [ "$OVERWRITE_PIA" == "o" ]; then
      echo -n "Enter your PIA username [${PREV_PIA_PASS}]: "
      read PIA_USERNAME
      echo -n "Enter your PIA password: "
      read -s PIA_PASSWORD
      echo ""
    fi
  else
    echo -n "Enter your PIA username: "
    read PIA_USERNAME
    echo -n "Enter your PIA password: "
    read -s PIA_PASSWORD
    echo ""
  fi

  wipe_old
  write_bashrc \
    "${CODE_DIR:-${PREV_CODE_DIR}}" \
    ;
  write_env \
    "${ENC_DIR_ACD:-${PREV_REMOTE_DIR}}" \
    "${ENCFS_CREDS:-${PREV_ENCFS_CREDS}}" \
    "${ENCFS6_CONFIG:-${PREV_ENCFS6_CONFIG}}" \
    "${MOUNT_DIR:-${PREV_MOUNT_DIR}}" \
    "${CODE_DIR:-${PREV_CODE_DIR}}" \
    "${PIA_USERNAME:-${PREV_PIA_USER}}" \
    "${PIA_PASSWORD:-${PREV_PIA_PASS}}" \
    ;

  return 0
}
write_bashrc() {
wipe_old
cat <<EOF >> "$BASHRC"
#processing-server-start

. "${1}/.env"
. "${1}/scripts/helper-functions.sh"
cd "${1}"

#processing-server-end
EOF

return 0
}
write_env() {
echo -n "  Writing environment variables to ${ENV_FILE}..."
rm -rf "${ENV_FILE:?notset}" 2>&1 || true
BIG_DRIVE_NAME=$(lsblk -x SIZE -o NAME,SIZE | tail -n 1 | awk '{print $1}')
cat <<EOT >> "$ENV_FILE"
export \\
  BIG_DRIVE_LOGICAL="/dev/${BIG_DRIVE_NAME}" \\
  BIG_DRIVE_MOUNT="${4:-/mnt/x}" \\
  CODE_DIR="${5:-/processing-server}" \\
  EDITOR="nano" \\
  ENC_DIR_REMOTE="${1:-/encrypted}" \\
  ENCFS_BIN="/usr/bin/encfs" \\
  ENCFS_CREDS="${2:-/.encfs}" \\
  ENCFS6_CONFIG="${3:-/encfs.xml}" \\
  PIA_PASS="${7}" \\
  PIA_USER="${6}" \\
  RCLONE_BIN="/usr/sbin/rclone" \\
  UMS_PASS="12345" \\
  UMS_USER="admin" \\
  ;

# DO NOT EDIT BELOW
export \\
  ENC_DIR_LOCAL="\${BIG_DRIVE_MOUNT}/encrypted" \\
  DEC_DIR_LOCAL="\${BIG_DRIVE_MOUNT}/decrypted" \\
  TEMP_DIR="\${BIG_DRIVE_MOUNT}/temp" \\
  CODE_DIR_SCRIPTS="\${CODE_DIR}/scripts" \\
  ;

log_msg() {
  echo -e "\$(date) \${1}: \${2}" | "\${TEE_BIN:-/usr/bin/tee}" -a "\${3:-/processing-server/logs/default.log}"
}

log_error() {
  log_msg "\e[31mERROR\e[0m" "\$1" "\$2" "\$3"
}

log_info() {
  log_msg "\e[36mINFO\e[0m" "\$1" "\$2" "\$3"
}

log_fatal() {
  log_msg "\e[101mFATAL\e[0m" "\$1" "\$2" "\$3"
}
EOT

return 0
}

prompt_for_creds
MSG="Environment variables set successfully." \
echo -e "\e[32m${MSG}\e[0m"

set +e
