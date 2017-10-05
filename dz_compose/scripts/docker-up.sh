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

source set_properties.sh "$1" "$2" "$3" "$properties_path"

echo "DOCKER_COMPOSE_FILE: ${DOCKER_COMPOSE_FILE}"

docker ${remote} stack deploy -c ${DOCKER_COMPOSE_FILE} "${STACK_NAME}"
