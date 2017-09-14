fly -t cicd login --team-name deetazilla-team -c http://ci.logimethodslabs.com:8080

fly -t cicd set-pipeline -p deetazilla-pipeline -c deetazilla-pipeline.yml --load-vars-from properties.yml --load-vars-from credentials.yml