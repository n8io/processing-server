#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR:-?}/.env"

TEE_BIN="${TEE_BIN:-/usr/bin/tee}"
SUBLIMINAL_BIN="${SUBLIMINAL_BIN:-/usr/local/bin/subliminal}"
LOG_FILE="${CODE_DIR}/subtitles.log"

find "${DEC_DIR_LOCAL:-?}" -type f -iname '*.mkv' -or -iname '*.mp4' -or -iname '*.avi' | xargs -I {} sh -c "${SUBLIMINAL_BIN} download -l en \"{}\"" | "$TEE_BIN" -a "$LOG_FILE"

set +e
