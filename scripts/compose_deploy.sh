#!/bin/bash

docker pull logimethods/int_cassandra_inject:1.0-dev

docker network create --attachable --driver overlay deetazilla
docker stack rm deetazilla
docker pull logimethods/int_compose:1.0-dev
docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.0-dev combine_services -p alt_properties -e "local" "single" "no_secrets" \
  inject streaming cassandra cassandra_inject > docker-compose-merge.yml
#  inject streaming monitor cassandra cassandra_inject > docker-compose-merge.yml
docker stack deploy -c docker-compose-merge.yml deetazilla
