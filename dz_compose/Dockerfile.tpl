FROM ((docker-dz_templater-repository)):((docker-dz_templater-tag))((docker-additional-tag))

COPY *.yml *.sh ./

ENTRYPOINT ["./combine_services_embedded.sh"]