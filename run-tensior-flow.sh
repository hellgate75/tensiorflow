#!/bin/bash

echo "Running TensiorFlow™ container ..."

start-tensoboard

if ! [[ -z "$1" ]] && [[ "-bash" == "$1" ]]; then
  if ! [[  -z "$2" ]]; then
    /bin/bash -c "${@:2}"
  fi
else

  echo "Running TensiorFlow™ TensoBoard logs : "
  tail -f /root/.tensoboard/tensoboard.log
  tail -f /dev/null
fi
