#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

mkdir -p \
  "${TEMP_DIR}/movies/prerelease" \
  "${TEMP_DIR}/movies/release" \
  "${TEMP_DIR}/tv" \
  "${ENC_DIR_LOCAL}" \
  "${DEC_DIR_LOCAL}/movies/prerelease" \
  "${DEC_DIR_LOCAL}/movies/release" \
  "${DEC_DIR_LOCAL}/tv/adult" \
  "${DEC_DIR_LOCAL}/tv/kids" \
  ;

MSG="Processing directories created successfully."; \
echo -e "\e[32m${MSG}\e[0m"

set +e
