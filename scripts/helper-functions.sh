#!/bin/bash
alias dc="docker-compose"
alias dcu="dc up -d"
alias dclog="dc logs"
alias dclogs="dclog"
alias dcstop="dc stop"
alias dcrm="dc rm"
alias dcrs="dc restart"

alias check="cat \"\${CODE_DIR}/.check\" 2>/dev/null || echo 0"
alias c="echo -e \"\n\e[94mEmpty run count: \$(check)\e[0m\n\" && du -h /mnt/x | grep -v \"encrypted\" | grep -v \"incomplete\" && echo \"\" "
alias czl="c && cat \"\${CODE_DIR}/enc-sync.log\" | tail -n 10 && echo \"\" "
alias cz="c && tail -f \"\${CODE_DIR}/enc-sync.log\""

DEF_ENC_DIR_LOCAL="$([ ! -z "$ENC_DIR_LOCAL" ] && echo "$ENC_DIR_LOCAL" || echo "/mnt/x/encrypted")"
DEF_ENCFS_CTL_BIN="$([ ! -z "$ENCFS_CTL_BIN" ] && echo "$ENCFS_CTL_BIN" || which encfsctl)"
DEF_ENCFS6_CONFIG="$([ ! -z "$ENCFS6_CONFIG" ] && echo "$ENCFS6_CONFIG" || echo "/encfs.xml")"

export \
  ENCFS6_CONFIG="${2:-$DEF_ENCFS6_CONFIG}" \
  ENCFS_CTL_BIN="${1:-$DEF_ENCFS_CTL_BIN}" \
  ENC_DIR_LOCAL="${3:-$DEF_ENC_DIR_LOCAL}" \
  ;

decode() {
  ENCFS6_CONFIG="$ENCFS6_CONFIG" "$ENCFS_CTL_BIN" decode . "$1"
}

encode() {
  ENCFS6_CONFIG="$ENCFS6_CONFIG" "$ENCFS_CTL_BIN" encode . "$1"
}
