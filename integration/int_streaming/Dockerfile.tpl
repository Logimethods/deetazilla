FROM maven:3-jdk-8-onbuild-alpine as mvn

# https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
# https://github.com/Logimethods/docker-eureka
FROM logimethods/eureka:entrypoint as entrypoint

##- FROM gettyimages/spark:2.2.0-hadoop-2.7
FROM ${spark_image}:${spark_version}-hadoop-${hadoop_version}

COPY --from=mvn /usr/src/app/target/*.jar ./

COPY --from=entrypoint eureka_utils.sh /eureka_utils.sh
COPY --from=entrypoint entrypoint.sh /entrypoint.sh

COPY entrypoint_insert.sh /entrypoint_insert.sh

EXPOSE 5005 4040

ENTRYPOINT ["/entrypoint.sh", "./bin/spark-submit"]
