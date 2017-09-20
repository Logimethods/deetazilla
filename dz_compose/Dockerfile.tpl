FROM ((docker-dz_templater-repository)):((docker-dz_templater-tag))((docker-additional-tag))

COPY *.yml *.sh ./

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN useradd -r -g docker docker

USER docker:docker

ENTRYPOINT ["./combine_services_embedded.sh"]