root="root root-${CLUSTER_MODE} root${SECRET_MODE}"

metrics="metrics $root"
spark="spark spark-${CLUSTER_MODE} $root"
cassandra="cassandra cassandra-image cassandra-${CLUSTER_MODE} $root"
hadoop="hadoop hadoop-${CLUSTER_MODE} $root"
zeppelin="zeppelin $root"
zeppelin-external_volumes="$zeppelin zeppelin-external_volumes $root"

root_metrics="root_metrics $root $metrics"

# TODO Add ALL metrics!
