#!/usr/bin/env sh
set -e -x
# Change to websockify root directory
cd "$(dirname "$0")/.."
# Build using the Dockerfile in the root
docker build -t novnc/websockify .
