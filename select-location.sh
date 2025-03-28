#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/functions.sh"

loadConfig

startConnecting

log "Listing locations:"
locations=$(logAndExec "$ADGUARD_BIN" list-locations | ansi2txt)

log "Locations list:"
log "$locations"

zenityListInput=()

# https://stackoverflow.com/a/63239490
fieldWidths=$(echo "$locations" | head -n 1 | grep -Po '\S+\s*' | awk '{printf "%d ", length($0)}' | sed 's/^[ ]*//;s/[ ]*$//')

function extractField {
  echo "$1" | awk "BEGIN {FIELDWIDTHS=\"$fieldWidths\"}{print \$$2 }" | sed 's/^[ ]*//;s/[ ]*$//'
}

while IFS= read -r line
do
  if [[ "$line" == "" ]]; then
    break
  fi

  # ISO
  zenityListInput+=("$(extractField "$line" 1)")
  # Country
  zenityListInput+=("$(extractField "$line" 2)")
  # City
  zenityListInput+=("$(extractField "$line" 3)")
  # Ping
  zenityListInput+=("$(extractField "$line" 4)")
done <<< "$(echo "$locations" | tail -n+2)"

fastestButtonText="Connect to fastest (Alt + _F)"

log "Showing locations list dialog:"

location=$(logAndExec zenity --list \
  --title "AdGuard VPN - Connection" \
  --text "Click Connect without selection to connect to the last location" \
  --window-icon "$SCRIPT_DIR/icons/trayicon_default.png" \
  --ok-label "Connect" \
  --extra-button "$fastestButtonText" \
  --column "ISO" --column "Country" --column "City" --column "Ping (ms)" \
  --print-column 3 \
  --width 400 \
  --height 400 \
  "${zenityListInput[@]}")

exitCode=$?

log "Locations list result: exit code $exitCode, location '$location'"

CONNECT="$SCRIPT_DIR/connect.sh"

if [ $exitCode -eq 0 ]; then
  if [[ "$location" == "" ]]; then
    log "Connecting: "
    logAndExec "$CONNECT"
  else
    log "Connecting: "
    logAndExec "$CONNECT" -l "$location"
  fi
elif [ "$location" == "$fastestButtonText" ]; then
  log "Connecting: "
  logAndExec "$CONNECT" --fastest
else
  endConnecting
fi
