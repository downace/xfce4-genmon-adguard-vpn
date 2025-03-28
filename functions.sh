#!/bin/bash

MARKER_FILE="$SCRIPT_DIR/genmon-vpn-status-connecting"

function loadConfig {
  if [ -f "$SCRIPT_DIR/config" ]; then
    source "$SCRIPT_DIR/config"
  fi

  ADGUARD_BIN=${ADGUARD_BIN:-adguardvpn-cli}
  WIDGET_NAME=${WIDGET_NAME:-genmon-1}
  NOPASSWD=${NOPASSWD:-0}
  LOCATION=${LOCATION:-}
}

function isConnecting {
  test -f "$MARKER_FILE"
}

function startConnecting {
  touch "$MARKER_FILE"
  xfce4-panel --plugin-event="$WIDGET_NAME:refresh:bool:true"
}

function endConnecting {
  rm "$MARKER_FILE"
  xfce4-panel --plugin-event="$WIDGET_NAME:refresh:bool:true"
}

function log {
  echo "[$(date --iso-8601=seconds)] $@" >> "$SCRIPT_DIR/main.log"
}

function logAndExec {
  log $@
  "$@"
}
