#!/bin/bash
set -e

SCRIPT="$(realpath "$0")"
CODE_DIR="$(dirname "$(dirname "$SCRIPT")")"
. "${CODE_DIR}/.env"

FUSERMOUNT_BIN="/bin/fusermount"

log_env() {
  echo -e "
    ENCFS_CREDS=${ENCFS_CREDS}
    ENCFS6_CONFIG=${ENCFS6_CONFIG}
    ENC_DIR_LOCAL=${ENC_DIR_LOCAL}
    DEC_DIR_LOCAL=${DEC_DIR_LOCAL}
  ";
}

unmount_dir() {
  "$FUSERMOUNT_BIN" -uz "$1" &>/dev/null || true
}

remove_old() {
  rm -f \
    "$ENCFS6_CONFIG" \
    "$ENCFS_CREDS" \
    ;
  rm -rf "$DEC_DIR_LOCAL"
}

check_for_previous_setup() {
  ([ -f "$ENCFS6_CONFIG" ] || [ -f "$ENCFS_CREDS" ]) && echo "true" || echo "false"
}

setup_encfs() {
  echo -n "Starting encryption config..."
  mkdir -p "$DEC_DIR_LOCAL"
  rm -rf "${ENC_DIR_LOCAL:?}/*"
  ENCFS6_CONFIG_TEMP="$ENCFS6_CONFIG"
  unset ENCFS6_CONFIG
  "${ENCFS_BIN:?}" --reverse "${DEC_DIR_LOCAL:?}" "${ENC_DIR_LOCAL:?}"
  echo -n "Verify Encfs Password one last time: "
  read -r -s PASSWORD
  echo ""
  echo "$PASSWORD" > "$ENCFS_CREDS"
  unmount_dir "${DEC_DIR_LOCAL}"
  unmount_dir "${ENC_DIR_LOCAL}"
  mv "${DEC_DIR_LOCAL}/.encfs6.xml" "$ENCFS6_CONFIG_TEMP"
  rm -rf "${DEC_DIR_LOCAL}/.encfs6.xml" &>/dev/null || true
  export ENCFS6_CONFIG="$ENCFS6_CONFIG_TEMP"
  #log_env
}

echo -n "Unmounting encrypted drives if mounted..."
unmount_dir "${DEC_DIR_LOCAL}"
unmount_dir "${ENC_DIR_LOCAL}"
echo "done."

EXISTS=$(check_for_previous_setup)
if [ "$EXISTS" = "true" ]; then
  echo -n "An existing encryption config was found. Do you want to overwrite or reuse? [o/R]: "
  read -r ANSWER
  echo ""
  [ "$ANSWER" = "o" ] && remove_old && setup_encfs
else
  setup_encfs
fi

#log_env
. "${CODE_DIR}/.env"

#log_env
cat "${ENCFS_CREDS:?}" | "$ENCFS_BIN" -S -o allow_other --reverse "${DEC_DIR_LOCAL:?}" "${ENC_DIR_LOCAL:?}"

mkdir -p \
  "${DEC_DIR_LOCAL}/movies/prerelease" \
  "${DEC_DIR_LOCAL}/movies/release" \
  "${DEC_DIR_LOCAL}/tv/adult" \
  "${DEC_DIR_LOCAL}/tv/kids" \
  ;

MSG="Encryption directory setup successfully"; \
echo -e "\e[32m${MSG}\e[0m"

set +e
