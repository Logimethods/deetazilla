#!/usr/bin/env bash
# https://github.com/docker/compose/issues/3435#issuecomment-232353235

STACK_NAME="$1"
shift 1
echo "STACK_NAME: ${STACK_NAME}"

set -a
location="$1"

echo "location: $location"

source properties/configuration.properties
source "properties/configuration-location-${location}.properties"
source "properties/configuration-location-${location}-debug.properties"
set +a

docker ${remote} stack rm "${STACK_NAME}"
