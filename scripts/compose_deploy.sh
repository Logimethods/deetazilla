#!/bin/bash

docker pull logimethods/int_compose:1.0-dev
docker run --rm logimethods/int_compose:1.0-dev combine_services  -e "local" "single" "_no-secrets" inject_metrics > docker-compose-merge.yml
docker stack deploy -c docker-compose-merge.yml deetazilla
