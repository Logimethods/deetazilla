/*
 * Copyright 2016-2017 Logimethods - Laurent Magnin
 */

//"Attempting to create an already existing keyspace will return an error unless the IF NOT EXISTS option is used." -> We don't want to erase existing data
CREATE KEYSPACE IF NOT EXISTS smartmeter WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE smartmeter;

CREATE TABLE IF NOT EXISTS max_voltage (
      epoch bigint,
      voltage float,
      PRIMARY KEY (epoch)
);

// http://docs.datastax.com/en/cql/3.3/cql/cql_using/useCounters.html
CREATE TABLE IF NOT EXISTS raw_data_count (
      slot ascii PRIMARY KEY,
      count counter
);
