#!/bin/bash

## docker run logimethods/smart-meter:compose "_secrets" inject_metrics

SECRET_MODE="$1"
shift 1

source ./services_hierarchies.sh

targets=$(echo "$@" | sed s/["^ "]*/'$'\&/g)

eval echo "$targets" \
  | xargs -n1 | sort -u | xargs \
  | sed s/["^ "]*/"## "\&/g

temp_file=$(mktemp)

yamlreader \
  $( eval echo "$targets" \
  | xargs -n1 | sort -u | xargs \
  | sed s/["^ "]*/docker-compose-\&.yml/g ) > "${temp_file}"

python3 templater.py "${temp_file}" properties/properties.yml
