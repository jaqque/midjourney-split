#!/bin/sh

set -eu

container_engine() {
  if command -v podman >/dev/null 2>&1; then
    podman "$@";
  elif command -v docker >/dev/null 2>&1; then
    docker "$@"
  else
    echo 'Unable to find a suitable container engine.'
    # shellcheck disable=SC2016
    echo 'Please ensure "podman" or "docker" is installed an in your $PATH'
    exit 1
  fi
}

cd "$(dirname "$0")"

registry='quay.io'
library='jaqque'
app='ninja-slice'
tag="$registry/$library/$app"
date_image='debian:12-slim'

now="$(date)"
time_of_day="$(container_engine run "$date_image" date -d "$now" +%T)"
seconds_since_midnight="$(container_engine run "$date_image" date -d "1970-01-01 UTC $time_of_day" +%s)"
today=$(container_engine run "$date_image" date -d "$now" +%Y%m%d)
date_label="$today.$seconds_since_midnight"

cd "$(dirname "$0")"

container_engine build --tag "$app" --tag "$tag:latest" --tag "$tag:$date_label" --file Containerfile .
