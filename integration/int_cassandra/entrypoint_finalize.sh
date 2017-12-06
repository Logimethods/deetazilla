#!/bin/bash

if [ -f ${CASSANDRA_SETUP_FILE} ] && [ -z "${PROVIDED_CASSANDRA_SEEDS}" ]; then
  echo "Will initialize Cassandra through ${CASSANDRA_SETUP_FILE}"
  cqlsh -f "${CASSANDRA_SETUP_FILE}"
fi

# Export the raw_data count
# https://stackoverflow.com/questions/16640054/minimal-web-server-using-netcat
if [ -n "${CASSANDRA_COUNT_PORT}" ]; then
  echo "Ready to provide 'select max(voltage) from smartmeter.max_voltage;' through the ${CASSANDRA_COUNT_PORT} port"
  (while true; do cqlsh -e "select max(voltage) from smartmeter.max_voltage;" | nc -l 6161 >/dev/null; done) &
fi
