#!/bin/bash

. set_properties_to_dockerfile_templates.sh

build_dockerfile_inject() {
  pushd docker_inject
  #sbt update
  #sbt test docker
  #sbt eclipse
  sbt clean assembly dockerFileTask
  pushd target/docker
  mv Dockerfile Dockerfile_middle
  cp ../../entrypoint_insert.sh .
  cat ../../Dockerfile_pre Dockerfile_middle ../../Dockerfile_post >> Dockerfile
  docker build -t logimethods/compose:inject$1 .
  popd
  popd
}

build_dockerfile_app_streaming() {
  pushd dockerfile-app-streaming
  #sbt update
  #sbt test docker
  #sbt eclipse
  sbt clean assembly dockerFileTask
  pushd target/docker
  mv Dockerfile Dockerfile_middle
  cp ../../entrypoint_insert.sh .
  cat ../../Dockerfile_pre Dockerfile_middle ../../Dockerfile_post >> Dockerfile
  docker build -t logimethods/compose:app-streaming$1 .
  popd
  popd
}

build_dockerfile_app_batch() {
  pushd dockerfile-app-batch
  sbt update test assembly eclipse
  mkdir -p libs
  mv target/scala-*/*.jar libs/
  docker build -t logimethods/compose:app-batch$1 .
  popd
}

build_dockerfile_prometheus() {
  pushd dockerfile-prometheus
  docker build -t logimethods/compose:prometheus$1 .
  popd
}

build_dockerfile_monitor() {
  pushd dockerfile-monitor
  sbt update
  sbt test docker
  sbt eclipse
  popd
}

build_dockerfile_cassandra() {
  pushd dockerfile-cassandra
  docker build -t logimethods/compose:cassandra$1 .
  popd
}

build_dockerfile_telegraf() {
  pushd dockerfile-telegraf
  docker build -t logimethods/compose:telegraf$1 .
  popd
}

build_dockerfile_cassandra_inject() {
  pushd dockerfile-cassandra-inject
  go get github.com/nats-io/go-nats
  docker build -t logimethods/compose:cassandra-inject$1 .
  popd
}
