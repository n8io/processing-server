#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

echo -n "Writing automount entry point to /etc/fstab..."
grep -q "${BIG_DRIVE_MOUNT}" /etc/fstab || echo "${BIG_DRIVE_LOGICAL}    ${BIG_DRIVE_MOUNT}    ext4    defaults    0    1" >> /etc/fstab
echo "done."
echo -n "Unmounting large drive if mounted..."
umount -l "${BIG_DRIVE_MOUNT}" 2>/dev/null || true
echo "done."
echo -n "Formatting large drive if unformatted..."
mkdir -p "${BIG_DRIVE_MOUNT}"
mkfs.ext4 "${BIG_DRIVE_LOGICAL}"
echo "done."
echo -n "Mounting large drive..."
mount -a
echo "done."
echo ""
MSG="Processing drive formatted and mounted successfully."
echo -e "\e[32m${MSG}\e[0m"

set +e
