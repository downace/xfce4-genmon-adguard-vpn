#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/functions.sh"

loadConfig

startConnecting

log "Disconnecting:"
logAndExec "$ADGUARD_BIN" disconnect

endConnecting
