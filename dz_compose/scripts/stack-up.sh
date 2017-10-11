#!/usr/bin/env bash

STACK_NAME="$1"
shift 1
echo "STACK_NAME: ${STACK_NAME}"

temp_file=$(mktemp)

./combine_services.sh -e "$@" > "${temp_file}"

echo "DOCKER_COMPOSE_FILE: ${temp_file}"

docker ${remote} stack deploy -c "${temp_file}" "${STACK_NAME}"
