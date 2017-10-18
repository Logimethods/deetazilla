#!/bin/bash

docker pull logimethods/int_compose:1.0-dev
docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.0-dev combine_services -p alt_properties -e "local" "single" "_no-secrets" inject_metrics streaming > docker-compose-merge.yml
docker stack deploy -c docker-compose-merge.yml deetazilla
