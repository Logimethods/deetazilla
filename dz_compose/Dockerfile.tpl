FROM ((docker-dz_templater-repository)):((docker-dz_templater-tag))((docker-additional-tag))

COPY *.yml *.sh scripts/*.sh ./

## To install envsubst
RUN apt-get update &&  apt-get install -y gettext-base

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -aG docker root

VOLUME ["./devsecrets"]

ENTRYPOINT ["./entrypoint.sh"]