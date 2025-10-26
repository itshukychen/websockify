#!/usr/bin/env sh
set -e -x
cd "$(dirname "$0")"
# Build from parent directory to include all source files in context
docker build -f Dockerfile -t novnc/websockify ..
