#!/bin/sh

set -eu
cd "$(dirname "$0")"

podman build -t ninja-slice .
