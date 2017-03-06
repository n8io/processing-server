#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$SCRIPT")"
. "${CODE_DIR}/.env"

"${CODE_DIR}/setup/01.server-update.sh"
"${CODE_DIR}/setup/02.mount-additional-volume.sh"
"${CODE_DIR}/setup/03.make-dirs.sh"
"${CODE_DIR}/setup/04.create-encryption.sh"
"${CODE_DIR}/setup/05.rclone-install.sh"
"${CODE_DIR}/setup/06.docker.sh"
"${CODE_DIR}/setup/98.summary.sh"

set +e
