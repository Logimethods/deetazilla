#!/usr/bin/env bash
# https://github.com/docker/compose/issues/3435#issuecomment-232353235

while getopts ":p:" opt; do
  case $opt in
    p) properties_path="$OPTARG"
    # echo "postfix: $postfix"
    ((shift_nb+=2))
    ;;
    \?) echo "Invalid option $OPTARG"
    ((shift_nb+=1))
    ;;
  esac
done

set -a
location="$1"
cluster_mode="$2"
postfix="$3"
properties_path="$4"

echo "location: $location"
echo "cluster_mode: $cluster_mode"
echo "postfix: $postfix"
echo "properties_path: $properties_path"

# https://stackoverflow.com/questions/10735574/include-source-script-if-it-exists-in-bash
include () {
    #  [ -f "$1" ] && source "$1" WILL EXIT...
    if [ -f $1 ]; then
        echo "source $1"
        source $1
    fi
}

include "../properties/configuration.properties"
include "${properties_path}/configuration.properties"

include "../properties/configuration-application.properties"
include "${properties_path}/configuration-application.properties"

include "../properties/configuration-location-${location}-debug.properties"
include "${properties_path}/configuration-location-${location}-debug.properties"

include "../properties/configuration-mode-${cluster_mode}.properties"
include "${properties_path}/configuration-mode-${cluster_mode}.properties"

include "../properties/configuration-mode-${cluster_mode}-debug.properties"
include "${properties_path}/configuration-mode-${cluster_mode}-debug.properties"

# TODO Include ALL configuration-telegraf[...].properties Files

include "../properties/configuration-telegraf.properties"
include "${properties_path}/configuration-telegraf.properties"

include "../properties/configuration-telegraf-debug.properties"
include "${properties_path}/configuration-telegraf-debug.properties"
set +a
