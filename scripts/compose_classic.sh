#!/bin/bash

docker_tag="1.5"

docker pull logimethods/int_compose:${docker_tag}
docker pull logimethods/int_inject:${docker_tag}
docker pull logimethods/int_streaming:${docker_tag}
docker pull logimethods/int_cassandra:${docker_tag}
#docker pull logimethods/int_cassandra_inject:1.5
docker pull logimethods/int_monitor:${docker_tag}

docker network create --attachable --driver overlay deetazilla
docker stack rm deetazilla
docker pull logimethods/int_compose:${docker_tag}

docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:${docker_tag} \
  combine_services -p alt_properties -e "local" "single" "no_secrets" \
  inject streaming monitoring > docker-compose-merge.yml

docker-compose -f docker-compose-merge.yml up

docker-compose -f docker-compose-merge.yml down
