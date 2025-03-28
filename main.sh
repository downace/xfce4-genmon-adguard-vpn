#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/functions.sh"

loadConfig

CONNECT_COMMAND="connect.sh"

case $LOCATION in
  "fastest")
    CONNECT_COMMAND="connect.sh --fastest"
    ;;
  "select")
    CONNECT_COMMAND="select-location.sh"
    ;;
  "")
    CONNECT_COMMAND="connect.sh"
    ;;
  *)
    CONNECT_COMMAND="connect.sh --location \"$LOCATION\""
    ;;
esac

STATUS_OUTPUT=$($ADGUARD_BIN status 2>&1)

exitCode="$?"

if [[ $exitCode != 0 ]]; then
  echo "<tool>$STATUS_OUTPUT</tool>"
  echo "<txt><span fgcolor='#ff6666'>AdGuard VPN status error</span></txt>"
  exit 1
fi

STATUS_TEXT=$(echo "$STATUS_OUTPUT" | ansi2txt | head -n 1)

echo "<tool><b>AdGuard VPN</b>
$STATUS_TEXT
Click to toggle connection</tool>"

if isConnecting ; then
  echo "<img>$SCRIPT_DIR/icons/connecting.png</img>"
elif [[ $STATUS_TEXT == *disconnected* ]]; then
  echo "<img>$SCRIPT_DIR/icons/disconnected.png</img><click>$SCRIPT_DIR/$CONNECT_COMMAND</click>"
else
  echo "<img>$SCRIPT_DIR/icons/connected.png</img><click>$SCRIPT_DIR/disconnect.sh</click>"
fi
