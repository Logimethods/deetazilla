FROM logimethods/yamlreader

RUN pip install pyyaml

COPY *.yml combine_services_embedded.sh services_hierarch*.sh ./
COPY templater/*.py ./templater/

ENTRYPOINT ["./combine_services_embedded.sh"]