#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/functions.sh"

loadConfig

startConnecting

if [[ "$NOPASSWD" == "1" ]]; then
  log "Connecting:"
  logAndExec "$ADGUARD_BIN" connect "$@"
else
  log "Connecting:"
  logAndExec xfce4-terminal --title 'AdGuard VPN Connection' --hide-menubar --execute "$ADGUARD_BIN" connect "$@"
fi

endConnecting
