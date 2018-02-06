#!/bin/bash

docker pull logimethods/int_compose:1.0-dev
docker pull logimethods/int_inject:1.0-dev
docker pull logimethods/int_streaming:1.0-dev
docker pull logimethods/int_cassandra:1.0-dev
#docker pull logimethods/int_cassandra_inject:1.0-dev
docker pull logimethods/int_monitor:1.0-dev

docker network create --attachable --driver overlay deetazilla
docker stack rm deetazilla
docker pull logimethods/int_compose:1.0-dev

docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.0-dev \
  combine_services -p alt_properties -e "local" "single" "no_secrets" \
  inject streaming monitoring > docker-compose-merge.yml

docker-compose -f docker-compose-merge.yml up

docker-compose -f docker-compose-merge.yml down
