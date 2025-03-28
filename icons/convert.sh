#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR" || exit

if ! command -v inkscape 2>&1 >/dev/null
then
  echo "Inkscape not found"
  exit 1
fi

icons=(default connecting connected disconnected)

w=${1:-24}
h=${2:-$w}

for icon in "${icons[@]}" ; do
  inkscape "$icon.svg" -w "$w" -h "$h" -o "$icon.png"
done
