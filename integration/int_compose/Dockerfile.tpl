FROM ((docker-dz_compose-repository)):((docker-dz_compose-tag))((docker-additional-tag))

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh \
    && useradd -r -u 1001 -g docker docker \
    && usermod -aG docker docker

USER docker

COPY services_hierarch*.sh scripts/*.sh ./
