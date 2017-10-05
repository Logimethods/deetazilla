#!/bin/bash

## docker run logimethods/smart-meter:compose "local" "single" "-DEV" "_secrets" inject_metrics

# https://github.com/docker/compose/issues/3435#issuecomment-232353235


while getopts ":p:e" opt; do
  case $opt in
    p) properties_path="$OPTARG"
    # echo "postfix: $postfix"
    ((shift_nb+=2))
    ;;
    e) env_set="true"
    # echo "postfix: $postfix"
    ((shift_nb+=2))
    ;;
    \?) echo "Invalid option $OPTARG"
    ((shift_nb+=1))
    ;;
  esac
done

## Set the properties when the '-e' option is provided
[ -n "$env_set" ] && ./set_properties.sh "$1" "$2" "$3" "$properties_path"

SECRET_MODE="$4"
shift 4

echo "# SECRET_MODE: $SECRET_MODE"

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
