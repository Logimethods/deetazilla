#!/bin/bash

set -e

. set_properties_to_dz_templates.sh

clear
echo "-----------------------------------------"
echo "dz_telegraf"
pushd dz-telegraf
docker build -t logimethods/dz_telegraf .
docker push logimethods/dz_telegraf
popd

clear
echo "-----------------------------------------"
echo "dz_cassandra"
pushd dz-cassandra
docker build -t logimethods/dz_cassandra .
docker push logimethods/dz_cassandra
popd


clear
echo "-----------------------------------------"
echo "dz_nats-server"
pushd dz_nats-server
docker build -t logimethods/dz_nats-server .
docker push logimethods/dz_nats-server
popd

clear
echo "-----------------------------------------"
echo "dz_nats-client"
pushd dz_nats-client
#go get github.com/nats-io/go-nats
#env GOOS=linux GOARCH=amd64 go build main.go
#file main
docker build -t logimethods/dz_nats-client .
docker push logimethods/dz_nats-client
popd

clear
echo "-----------------------------------------"
echo "compose"
pushd compose
docker build -t logimethods/dz_compose .
docker push logimethods/dz_compose
popd
