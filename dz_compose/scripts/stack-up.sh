#!/usr/bin/env bash

temp_file=$(mktemp)

./combine_services.sh -e "$@" > "${temp_file}"

echo "DOCKER_COMPOSE_FILE: ${temp_file}"

docker ${remote} stack deploy -c "${temp_file}" "${STACK_NAME}"
