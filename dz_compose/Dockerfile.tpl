FROM ((docker-dz_templater-repository)):((docker-dz_templater-tag))((docker-additional-tag))

COPY *.yml *.sh scripts/*.sh ./

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -aG docker root

ENTRYPOINT ["./combine_services_embedded.sh"]