FROM maven:3-jdk-8-onbuild-alpine as mvn

# https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
# https://github.com/Logimethods/docker-eureka
FROM logimethods/eureka:entrypoint as entrypoint

##- FROM frolvlad/alpine-scala:2.11
FROM ${scala_image}:${scala_main_version}

# https://stedolan.github.io/jq/
RUN apt-get update && apt-get install -y \
  jq netcat-openbsd dnsutils
  # bash iputils-ping curl

COPY --from=mvn /usr/src/app/target/*.jar ./

COPY --from=entrypoint eureka_utils.sh /eureka_utils.sh
COPY --from=entrypoint entrypoint.sh /entrypoint.sh

COPY entrypoint_insert.sh /entrypoint_insert.sh

COPY spark/conf/*.properties ./conf/

# EXPOSE 5005 4040

ENTRYPOINT ["scala", "-cp", "int_monitor-latest.jar"]
