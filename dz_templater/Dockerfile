## https://github.com/ImmobilienScout24/yamlreader

FROM python:3.6.2-jessie

RUN pip install yamlreader

WORKDIR /templater

RUN chmod 777 /templater

VOLUME /files

COPY python/templater.py ./python/
COPY *.sh scripts/*.sh *.yml ./
COPY properties/* ./properties/

ENTRYPOINT ["./entrypoint.sh"]