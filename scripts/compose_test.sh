#!/bin/bash

docker network create --attachable --driver overlay deetazilla
docker stack rm deetazilla
docker pull logimethods/int_compose:1.5-dev

docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.5-dev \
  combine_services -p alt_properties -e "local" "single" "no_secrets" \
  inject streaming > docker-compose-merge.yml

docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.5-dev \
  combine_services -p alt_properties -e "local" "single" "no_secrets" \
  test > docker-compose-merge.test.yml

(docker-compose -f docker-compose-merge.yml up) &
sleep 10
echo "RUN SUT"
docker-compose -f docker-compose-merge.test.yml run sut
rc=$?
echo "SUT Exit: $rc"
docker-compose -f docker-compose-merge.yml down
exit $rc