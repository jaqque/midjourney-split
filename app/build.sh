#!/bin/sh

set -eu

registry='quay.io'
library='jaqque'
app='ninja-slice'
tag="$registry/$library/$app"

now="$(date)"
seconds_since_midnight="$(date -d "1970-01-01 UTC $(date -d "$now" +%T)" +%s)"
today=$(date -d "$now" +%Y%m%d)
date_label="$today.$seconds_since_midnight"

cd "$(dirname "$0")"

podman build --tag "$tag:latest" --tag "$tag:$date_label" .
