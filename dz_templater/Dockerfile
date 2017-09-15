## https://github.com/ImmobilienScout24/yamlreader

FROM python:3.6.2-alpine3.6

RUN pip install yamlreader

WORKDIR /templater

COPY *.yml *.sh .
COPY properties/* ./properties/

VOLUME /files

ENTRYPOINT ["yamlreader"]