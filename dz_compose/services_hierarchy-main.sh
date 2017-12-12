root="base root root-${CLUSTER_MODE} root-${SECRET_MODE} root-${SECRET_MODE}-${CLUSTER_MODE}"
metrics="metrics"
root_metrics="root_metrics $root $metrics"
root_debug="root_debug root_debug-${SECRET_MODE} $root"
root_metrics_debug="root_metrics root_debug $root"

spark="spark spark-${CLUSTER_MODE} $root"
cassandra="cassandra cassandra-image cassandra-${CLUSTER_MODE} $root"
hadoop="hadoop hadoop-${CLUSTER_MODE} $root"
zeppelin="zeppelin $root"
zeppelin_external_volumes="$zeppelin zeppelin-external_volumes"


# TODO Add ALL metrics!
