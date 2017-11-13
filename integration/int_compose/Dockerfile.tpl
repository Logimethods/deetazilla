FROM ((docker-dz_compose-repository)):((docker-dz_compose-tag))((docker-additional-tag))

COPY *.sh ./
COPY compose/*.yml ./
COPY properties/* ./properties/

RUN mv ./properties/configuration.properties ./properties/configuration.properties.TMP
RUN cat ./properties/configuration.properties.TMP ./properties/configuration-additional.properties >> ./properties/configuration.properties
RUN rm ./properties/configuration.properties.TMP