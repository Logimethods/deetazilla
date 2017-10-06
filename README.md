# unnamed_bd
All you need to build your own (Big) Data &amp; IOT oriented application

## Docker Compose

* To create your `docker-compose-merge.yml` file thanks to [combine_services.sh](./dz_compose/scripts/combine_services.sh), which makes use of [yamlreader](https://github.com/ImmobilienScout24/yamlreader):
    * Free Properties
      * When Docker Secrets are provided:    
      `> docker run logimethods/int_compose combine_services "_secrets" root_metrics spark > docker-compose-merge.yml`
      * When Docker Secrets are NOT provided:    
      `> docker run logimethods/int_compose combine_services "_no-secrets" root_metrics spark > docker-compose-merge.yml`
    * Making use of Properties Files
      * When Docker Secrets are provided:    
      `> docker run logimethods/int_compose combine_services -e "local" "single" "-DEV" "_secrets" root_metrics spark > docker-compose-merge.yml`
      * When Docker Secrets are NOT provided:    
      `> docker run logimethods/int_compose combine_services -e "local" "single" "-DEV" "_no-secrets" root_metrics spark > docker-compose-merge.yml`

    * To directly start the services:
      ```
      > docker run -it -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.0-dev stack-up "local" "single" "_secrets" root_metrics spark
      ```
