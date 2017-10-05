# unnamed_bd
All you need to build your own (Big) Data &amp; IOT oriented application

## Docker Compose

* To create your `docker-compose-merge.yml` file thanks to [combine_services.sh](./dz_compose/scripts/combine_services.sh), which makes use of [yamlreader](https://github.com/ImmobilienScout24/yamlreader):
    * Free Properties
      * When Docker Secrets are provided:    
      `docker run logimethods/int_compose combine_services "_secrets" root_metrics spark > docker-compose-merge.yml`
      * When Docker Secrets are NOT provided:    
      `docker run logimethods/int_compose combine_services "_no-secrets" root_metrics spark > docker-compose-merge.yml`
    * Making use of Properties Files
      * When Docker Secrets are provided:    
      `docker run logimethods/int_compose combine_services -e "local" "single" "-DEV" "_secrets" root_metrics spark > docker-compose-merge.yml`
      * When Docker Secrets are NOT provided:    
      `docker run logimethods/int_compose combine_services -e "local" "single" "-DEV" "_no-secrets" root_metrics spark > docker-compose-merge.yml`

* Last, but not least, start the services based on the previously generated `docker-compose-merge.yml` file:
```
./docker-[local | remote]-[single | cluster]-up.sh
.../...
./docker-[local | remote]-down.sh
```

```
> docker run -it -v /var/run/docker.sock:/var/run/docker.sock  --entrypoint="bash" logimethods/int_compose:1.0-dev
root@a0bd979b0402:/templater# ./combine_services_embedded.sh "_no-secrets" root_metrics > docker-compose-merge.yml
root@a0bd979b0402:/templater# ./docker-local-single-up.sh
```
