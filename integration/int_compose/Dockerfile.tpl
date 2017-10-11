FROM ((docker-dz_compose-repository)):((docker-dz_compose-tag))((docker-additional-tag))

COPY *.yml services_hierarch*.sh ./