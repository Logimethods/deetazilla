## https://github.com/ImmobilienScout24/yamlreader

FROM python:3.6.2-jessie

RUN pip install yamlreader

WORKDIR /templater

RUN chmod 777 /templater

COPY *.yml *.sh templater/templater.py ./
COPY properties/* ./properties/

## VOLUME /files

ENTRYPOINT ["yamlreader"]