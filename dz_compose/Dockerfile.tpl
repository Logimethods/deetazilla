FROM ((docker-dz_templater-repository)):((docker-dz_templater-tag))((docker-additional-tag))


## To install envsubst
RUN apt-get update &&  apt-get install -y gettext-base

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -aG docker root

VOLUME ["./devsecrets"]

COPY *.sh scripts/*.sh ./
COPY compose/*.yml ./
COPY properties/* ./properties/
COPY runtime_properties/* ./runtime_properties/