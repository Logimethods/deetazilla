#!/usr/bin/env bash
# https://github.com/docker/compose/issues/3435#issuecomment-232353235

STACK_NAME="$1"
shift 1
echo "STACK_NAME: ${STACK_NAME}"

set -a
location="$1"

echo "location: $location"

# https://stackoverflow.com/questions/10735574/include-source-script-if-it-exists-in-bash
include () {
    #  [ -f "$1" ] && source "$1" WILL EXIT...
    if [ -f $1 ]; then
        echo "# source $1"
        source $1
    fi
}

include properties/configuration.properties
include "properties/configuration-application.properties"
include "properties/configuration-location-${location}.properties"
include "properties/configuration-location-${location}-debug.properties"
set +a

docker ${remote} stack rm "${STACK_NAME}"
