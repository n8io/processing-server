#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

cd /
curl -O -s http://downloads.rclone.org/rclone-current-linux-amd64.zip >/dev/null
unzip -oq rclone-current-linux-amd64.zip > /dev/null
cd rclone-*-linux-amd64
cp rclone /usr/sbin/
chown root:root /usr/sbin/rclone
chmod 755 /usr/sbin/rclone
mkdir -p /usr/local/share/man/man1
cp rclone.1 /usr/local/share/man/man1/
mandb -q
rm /rclone-current*
"$RCLONE_BIN" config
cd -
MSG="Rclone installed successfully."; \
echo -e "\e[32m${MSG}\e[0m"

set +e
