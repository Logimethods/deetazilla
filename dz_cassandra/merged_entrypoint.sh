#!/bin/bash
set -e

#### EUREKA ###

if [ $(whoami) = 'root' ]; then
  # https://stackoverflow.com/questions/39162846/what-does-set-e-and-set-a-do-in-bash-what-are-other-options-that-i-can-use-wit
  if [ -n "${EUREKA_DEBUG}" ]; then
    echo "EUREKA_DEBUG MODE, no exit on exception"
  else
    set -e
  fi

  source /eureka_utils.sh

  cmdpid=$BASHPID ;
  include /entrypoint_insert.sh

  run_tasks 'INIT'
  (run_tasks "CONTINUOUS_CHECK_INIT#$cmdpid") &
  include /entrypoint_prepare.sh ;
  if [ -z "${READY_WHEN}" ]; then
    enable_availability;
  fi ;

  if [[ $PROVIDED_CASSANDRA_SEEDS = \$* ]]; then # If CASSANDRA_SEEDS starts with a $
    export CASSANDRA_SEEDS=$(eval echo "$PROVIDED_CASSANDRA_SEEDS")
  else
    export CASSANDRA_SEEDS="${PROVIDED_CASSANDRA_SEEDS}"
  fi

  echo "PROVIDED_CASSANDRA_SEEDS:: ${PROVIDED_CASSANDRA_SEEDS}"
  echo "CASSANDRA_SEEDS:: ${CASSANDRA_SEEDS}"
fi

### CASSANDRA ###

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- cassandra -f "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'cassandra' -a "$(id -u)" = '0' ]; then
	chown -R cassandra /var/lib/cassandra /var/log/cassandra "$CASSANDRA_CONFIG"
  exec gosu cassandra "$BASH_SOURCE" "$@" 2>&1
fi

if [ "$1" = 'cassandra' ]; then
	: ${CASSANDRA_RPC_ADDRESS='0.0.0.0'}

	: ${CASSANDRA_LISTEN_ADDRESS='auto'}
	if [ "$CASSANDRA_LISTEN_ADDRESS" = 'auto' ]; then
		CASSANDRA_LISTEN_ADDRESS="$(hostname --ip-address)"
	fi

	: ${CASSANDRA_BROADCAST_ADDRESS="$CASSANDRA_LISTEN_ADDRESS"}

	if [ "$CASSANDRA_BROADCAST_ADDRESS" = 'auto' ]; then
		CASSANDRA_BROADCAST_ADDRESS="$(hostname --ip-address)"
	fi
	: ${CASSANDRA_BROADCAST_RPC_ADDRESS:=$CASSANDRA_BROADCAST_ADDRESS}

	if [ -n "${CASSANDRA_NAME:+1}" ]; then
		: ${CASSANDRA_SEEDS:="cassandra"}
	fi
	: ${CASSANDRA_SEEDS:="$CASSANDRA_BROADCAST_ADDRESS"}

	sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_CONFIG/cassandra.yaml"

	for yaml in \
		broadcast_address \
		broadcast_rpc_address \
		cluster_name \
		endpoint_snitch \
		listen_address \
		num_tokens \
		rpc_address \
		start_rpc \
	; do
		var="CASSANDRA_${yaml^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_CONFIG/cassandra.yaml"
		fi
	done

	for rackdc in dc rack; do
		var="CASSANDRA_${rackdc^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^('"$rackdc"'=).*/\1 '"$val"'/' "$CASSANDRA_CONFIG/cassandra-rackdc.properties"
		fi
	done
fi

### EXEC CMD ###

if [ -n "${READY_WHEN}" ] || [ -n "${FAILED_WHEN}" ]; then
  log 'info' "Ready/Failed Monitoring Started"
  ## https://stackoverflow.com/questions/4331309/shellscript-to-monitor-a-log-file-if-keyword-triggers-then-execute-a-command
  exec "$@" | \
    while read line ; do
      echo "${EUREKA_LINE_START}${line}"
      monitor_output "$line" $cmdpid
    done
else
  log 'info' "Started without Monitoring"
  exec "$@"
fi

if [[ $EUREKA_DEBUG = *stay* ]]; then
  log 'info' "STAY FOREVER!!!"
  while true; do sleep 100000 ; done
fi
