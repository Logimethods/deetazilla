# Deetazilla
All you need to build your own (Big) Data &amp; IOT oriented application

```
docker network create --attachable --driver overlay deetazilla
```

## Docker Compose File

* To create your `docker-compose-merge.yml` file thanks to [combine_services.sh](./dz_compose/scripts/combine_services.sh), which makes use of [yamlreader](https://github.com/ImmobilienScout24/yamlreader):
    * Free Properties
      * When Docker Secrets are provided:    
      ```
      > docker run --rm logimethods/int_compose:1.5 combine_services "[single|cluster]" "secrets" root_metrics spark > docker-compose-merge.yml
      ```
      * When Docker Secrets are NOT provided:    
      ```
      > docker run --rm logimethods/int_compose:1.5 combine_services "[single|cluster]" "no_secrets" root_metrics spark > docker-compose-merge.yml
      ```
    * Making use of Properties Files
      * When Docker Secrets are provided:    
      ```
      > docker run --rm logimethods/int_compose:1.5 combine_services -e "local" "[single|cluster]" "secrets" root_metrics spark > docker-compose-merge.yml
      ```
      * When Docker Secrets are NOT provided:    
      ```
      > docker run --rm logimethods/int_compose:1.5 combine_services -e "local" "[single|cluster]" "no_secrets" root_metrics spark > docker-compose-merge.yml
      ```
      * To enforce Additional Properties (here located in `alt_properties`):
      ```
      > docker run --rm -v `pwd`/alt_properties:/templater/alt_properties logimethods/int_compose:1.5 combine_services -p alt_properties -e "local" "[single|cluster]" "secrets" root_metrics spark
      ```

    * To directly start the services:
      ```
      > docker run --rm -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.5 stack-up "stack_name" "local" "[single|cluster]" "no_secrets" root_metrics spark
      ```
      Or with Docker secrets
      ```
      > docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`/devsecrets:/templater/devsecrets logimethods/int_compose:1.5 stack-up "stack_name" "local" "[single|cluster]" "secrets" root_metrics spark
      ```
      You might also use a shortcut (`local-single-up`, `local-cluster-up`, `remote-single-up` or `remote-cluster-up`):
      ```
      > docker run --rm -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.5 local-single-up "stack_name" "[single|cluster]" "no_secrets" root_metrics spark
      ```

    * Then, to stop the stack:
      ```
      docker run --rm -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.5 \
         stack-down "stack_name" "local"
      ```
      Or
      ```
      docker run --rm -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.5 \
         local-down "stack_name"
      ```
      Or
      ```
      docker run --rm -v /var/run/docker.sock:/var/run/docker.sock logimethods/int_compose:1.5 \
         remote-down "stack_name"
      ```

## "Docker Compose" Script

```
cd scripts
./compose_classic.sh
```