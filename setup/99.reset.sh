#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"; \

echo -n "This cannot be undone. Are you sure you want to do this? [y/N] " && \
read ANSWER && \
if [ -z "$ANSWER" ]; then exit 1; fi && \
if [ ! "$ANSWER" == "y" ]; then exit 1; fi && \
cd / && \
screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill &>/dev/null || true && \
umount -l "$DEC_DIR_LOCAL" &>/dev/null || true && \
umount -l "$ENC_DIR_LOCAL" &>/dev/null || true && \
rm -rf "$DEC_DIR_LOCAL" && \
rm -rf "$ENC_DIR_LOCAL" && \
rm -rf "$CODE_DIR" && \
rm -rf "$TEMP_DIR" && \
rm -rf "$ENCFS_CREDS" && \
rm -rf "$ENCFS6_CONFIG" && \
MSG="Reset successful"; \
echo -e "\e[32m${MSG}\e[0m"

set +e
