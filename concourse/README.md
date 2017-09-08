fly -t cicd login --team-name laurent-team -c http://ci.logimethodslabs.com:8080

fly -t cicd set-pipeline -p unnamed-pipeline -c unnamed-pipeline.yml --load-vars-from properties.yml --load-vars-from credentials.yml