## MIT License
##
## Copyright (c) 2016-2017 Logimethods
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

###
# https://blog.frankel.ch/dockerfile-maven-based-github-projects/#gsc.tab=0

FROM alpine/git as github
WORKDIR /app
RUN git clone https://github.com/nabto/cassandra-prometheus.git

FROM maven:3-jdk-8-alpine as maven
WORKDIR /app
COPY --from=github /app/cassandra-prometheus /app
RUN mvn package

# https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
# https://github.com/Logimethods/docker-eureka
FROM logimethods/eureka:entrypoint as entrypoint
#FROM entrypoint_exp as entrypoint

### MAIN FROM ###

# https://hub.docker.com/_/cassandra/
FROM cassandra:${cassandra_version}

### Cassandra prometheus exporter ###

##! Warning: Cannot create directory at `/home/cassandra/.cassandra`. Command history will not be saved.
RUN chown cassandra /home/cassandra/

##! /eureka_utils.sh: line 412: /availability.lock: Permission denied
ENV AVAILABILITY_LOCK_PATH=/home/cassandra

# https://github.com/nabto/cassandra-prometheus
COPY --from=maven /app/target/cassandra-prometheus-${cassandra_prometheus_version}-jar-with-dependencies.jar /usr/share/cassandra/lib/
RUN echo 'JVM_OPTS="$JVM_OPTS -javaagent:/usr/share/cassandra/lib/cassandra-prometheus-${cassandra_prometheus_version}-jar-with-dependencies.jar=7400"' >> /etc/cassandra/cassandra-env.sh

### EUREKA ###

RUN apt-get update && apt-get install -y --no-install-recommends jq curl netcat-openbsd && rm -rf /var/lib/apt/lists/*

EXPOSE 6161

COPY --from=entrypoint eureka_utils.sh /eureka_utils.sh
COPY merged_entrypoint.sh /merged_entrypoint.sh
RUN chmod +x /merged_entrypoint.sh
ENTRYPOINT ["/merged_entrypoint.sh"]

HEALTHCHECK --interval=5s --timeout=1s --retries=1 CMD test -f /home/cassandra/availability.lock

ENV READY_WHEN="Created default superuser role"

## !!! ENTRYPOINT generates CMD amnesia !!!
CMD ["cassandra", "-f"]
