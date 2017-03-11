#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

rm -rf \
  "${CODE_DIR}/clean.log" \
  "${CODE_DIR}/enc-creates.log" \
  "${CODE_DIR}/subtitles.log" \
  ;

set +e
