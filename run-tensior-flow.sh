#!/bin/bash

echo "Running TensorFlow™ container ..."

if ! [[ -e /dev/nvidia0  ]]; then
  if [[ -e /dev/nvidia-uvm  ]]; then
    ln -s /dev/nvidia-uvm /dev/nvidia0
  else
    echo "No Nvidia Card present, please try to run container with nvidia-docker ..."
  fi
fi

if ! [[ -z "$1" ]] && [[ "-bash" == "$1" ]]; then
  echo "Starting TensorBoard™ ..."
  start-tensoboard
  if ! [[  -z "$2" ]]; then
    /bin/bash -c "${@:2}"
  fi
else
  if ! [[ -e /root/go/src/$PACKAGE_NAME ]]; then
    ln -s /root/tf-app /root/go/src/$PACKAGE_NAME
  fi
  if [[ "true" == "$AUTO_BUILD" ]]; then
    echo "Building and install Go Custom Package : $PACKAGE_NAME"
    echo "Building Argument : $BUILD_ARGUMENTS"
    echo "Repeat At Start-Up : $REPEAT_BUILD"
    echo ""
    echo ""
    if ! [[ -e /root/app_built ]]; then
      go install "$BUILD_ARGUMENTS" $PACKAGE_NAME
      if [[ "true" != "$REPEAT_BUILD" ]]; then
        touch /root/app_built
      fi
    fi
  fi

  echo "Starting TensorBoard™ ..."
  start-tensoboard

  echo "Running TensiorFlow™ TensoBoard logs : "

  tail -f /root/.tensoboard/tensoboard.log
  tail -f /dev/null
fi
