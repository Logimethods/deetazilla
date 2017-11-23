/*
 * Copyright 2016-2017 Logimethods - Laurent Magnin
 */

//"Attempting to create an already existing keyspace will return an error unless the IF NOT EXISTS option is used." -> We don't want to erase existing data
CREATE KEYSPACE IF NOT EXISTS smartmeter WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE smartmeter;

CREATE TABLE IF NOT EXISTS max_voltage (
      voltage float
);
