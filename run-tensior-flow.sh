#!/bin/bash

echo "Running TensiorFlow™ container ..."

if ! [[ -z "$1" ]] && [[ "-bash" == "$1" ]]; then
  if ! [[  -z "$2" ]]; then
    /bin/bash -c "${@:2}"
  fi
else
  tail -f /dev/null
fi
