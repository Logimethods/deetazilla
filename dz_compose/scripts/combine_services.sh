#!/bin/bash

## ./combine_services.sh "_secrets" root cassandra
## ./combine_services.sh -e "local" "single" "_secrets" root cassandra

# https://github.com/docker/compose/issues/3435#issuecomment-232353235

shift_nb=0
while getopts ":p:e" opt; do
  case $opt in
    p) properties_path="$OPTARG"
    ((shift_nb+=2))
    ;;
    e) env_set="true"
    echo "# -e to set properties"
    ((shift_nb+=1))
    ;;
    \?) echo "Invalid option $OPTARG"
    ((shift_nb+=1))
    ;;
  esac
done
shift $shift_nb

## Set the properties when the '-e' option is provided
[ -n "$env_set" ] && source set_properties.sh "$1" "$2" "${properties_path:=_NONE_}" && shift 2

SECRET_MODE="$1"
shift 1

echo "# SECRET_MODE: $SECRET_MODE"
echo "# TARGETS: $@"

source ./services_hierarchies.sh

targets=$(echo "$@" | sed s/["^ "]*/'$'\&/g)

echo ""

eval echo "$targets" \
  | xargs -n1 | sort -u | xargs \
  | sed s/["^ "]*/"## "\&/g

temp_file=$(mktemp)

yamlreader \
  $( eval echo "$targets" \
  | xargs -n1 | sort -u | xargs \
  | sed s/["^ "]*/docker-compose-\&.yml/g ) > "${temp_file}"

if [ -n "$env_set" ]; then
  python3 templater.py "${temp_file}" properties/properties.yml | envsubst
else
  python3 templater.py "${temp_file}" properties/properties.yml
fi
