## https://github.com/ImmobilienScout24/yamlreader

FROM python:3.6.2-jessie

RUN pip install yamlreader

WORKDIR /templater

RUN chmod 777 /templater

VOLUME /files

COPY *.yml *.sh ./
COPY python/templater.py ./python/
COPY properties/* ./properties/
COPY *.sh scripts/*.sh ./

ENTRYPOINT ["./entrypoint.sh"]