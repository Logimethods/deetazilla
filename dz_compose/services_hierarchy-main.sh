root="root root${SECRET_MODE}"

metrics="metrics $root"
spark="spark $root"
cassandra="cassandra $root"
hadoop="hadoop $root"
zeppelin="zeppelin $root"
zeppelin-external_volumes="zeppelin-external_volumes $zeppelin"

root_metrics="root_metrics $root $metrics"

# TODO Add ALL metrics!
