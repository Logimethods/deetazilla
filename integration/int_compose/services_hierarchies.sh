source ./services_hierarchy-main.sh

inject="inject inject${SECRET_MODE} $root"
inject_metrics="$inject $metrics"

cassandra_inject="$root $cassandra cassandra_inject${SECRET_MODE}"
cassandra_inject_metrics="cassandra_inject_metrics $cassandra $metrics"

streaming="streaming streaming${SECRET_MODE} $root $spark"
streaming_metrics="streaming_metrics streaming_metrics${SECRET_MODE} $streaming $metrics"

monitoring="monitoring monitoring${SECRET_MODE} $root"
monitoring_metrics="monitoring_metrics $monitoring $metrics"

integration_app="$inject $streaming $monitoring"
integration_app_monitoring="$inject_monitoring $streaming_monitoring $monitoring_monitoring"

