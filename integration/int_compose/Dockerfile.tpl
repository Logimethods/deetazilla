FROM ((docker-dz_compose-repository)):((docker-dz_compose-tag))((docker-additional-tag))

## Install Docker
RUN curl -sSL https://get.docker.com/ | sh

COPY services_hierarch*.sh scripts/*.sh ./
