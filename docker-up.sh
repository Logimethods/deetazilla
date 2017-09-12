#!/usr/bin/env bash
# https://github.com/docker/compose/issues/3435#issuecomment-232353235

set -a
location="$1"
cluster_mode="$2"
postfix="$3"

echo "location: $location"
echo "cluster_mode: $cluster_mode"
echo "postfix: $postfix"

# https://stackoverflow.com/questions/10735574/include-source-script-if-it-exists-in-bash
include () {
    #  [ -f "$1" ] && source "$1" WILL EXIT...
    if [ -f $1 ]; then
        echo "source $1"
        source $1
    fi
}

include "properties/configuration.properties"
include "properties/configuration-application.properties"
include "properties/configuration-location-${location}.properties"
include "properties/configuration-location-${location}-debug.properties"
include "properties/configuration-mode-${cluster_mode}.properties"
include "properties/configuration-mode-${cluster_mode}-debug.properties"
include "properties/configuration-telegraf.properties"
include "properties/configuration-telegraf-debug.properties"
set +a

echo "DOCKER_COMPOSE_FILE: ${DOCKER_COMPOSE_FILE}"

docker ${remote} stack deploy -c ${DOCKER_COMPOSE_FILE} "${STACK_NAME}"
