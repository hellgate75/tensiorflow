#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

if [ -z "$NOTEBOOK_DIR" ]; then
  export NOTEBOOK_DIR=/root/go/src/$PACKAGE_NAME
fi

notebook_arg=""
if [ -n "${NOTEBOOK_DIR:+x}" ]
then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

. run-jupyter jupyterhub-singleuser \
  --port=${JPY_PORT:-8888} \
  --ip=0.0.0.0 \
  --user=${JPY_USER:-$NB_USER} \
  --cookie-name=${JPY_COOKIE_NAME:-"notebook"} \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@
