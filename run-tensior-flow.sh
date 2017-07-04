#!/bin/bash

echo "Running TensiorFlow™ container ..."

start-tensoboard

if ! [[ -e /dev/nvidia0  ]]; then
  if [[ -e /dev/nvidia-uvm  ]]; then
    ln -s /dev/nvidia-uvm /dev/nvidia0
  else
    echo "No Nvidia Card present, please try to run container with nvidia-docker ..."
  fi
fi

if ! [[ -z "$1" ]] && [[ "-bash" == "$1" ]]; then
  if ! [[  -z "$2" ]]; then
    /bin/bash -c "${@:2}"
  fi
else
  echo "Running TensiorFlow™ TensoBoard logs : "
  tail -f /root/.tensoboard/tensoboard.log
  tail -f /dev/null
fi
