## https://github.com/ImmobilienScout24/yamlreader

FROM python:3.6.2-jessie

RUN pip install yamlreader

USER docker:docker

WORKDIR /templater

COPY *.yml *.sh *.py ./
COPY properties/* ./properties/

VOLUME /files

ENTRYPOINT ["yamlreader"]