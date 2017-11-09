fly -t cicd login --team-name deetazilla-team -c http://ci.logimethodslabs.com:8080

fly -t cicd set-pipeline -p deetazilla-pipeline -c deetazilla-pipeline.yml --load-vars-from ../dz_templater/properties/properties.yml --load-vars-from ../dz_templater/properties/properties_branch.yml --load-vars-from ../integration/int_compose/properties/properties_int.yml --load-vars-from credentials.yml