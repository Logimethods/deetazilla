source ./services_hierachy-main.sh

inject="inject inject${SECRET_MODE} $root $cassandra"
inject_metrics="inject_metrics $inject $metrics"

streaming="streaming streaming${SECRET_MODE} $root $spark"
streaming_metrics="streaming_metrics streaming_metrics${SECRET_MODE} $streaming $metrics"

monitoring="monitoring monitoring${SECRET_MODE} $root"
monitoring_metrics="monitoring_metrics $monitoring $metrics"

