#!/usr/bin/env bash

: "${DASK_SCHEDULER_HOST:="dask-scheduler"}"
: "${DASK_SCHEDULER_PORT:="8786"}"

case "$1" in
  scheduler)
    dask-scheduler
    ;;
  worker)
    dask-worker tcp://${DASK_SCHEDULER_HOST}:${DASK_SCHEDULER_PORT}
    ;;
  *)
    # generic command for to execute a workflow
    pwd
    ls -l
    python -u "$@.py"
    ;;
esac
