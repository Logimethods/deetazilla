/*******************************************************************************
 * Copyright (c) 2016-17 Logimethods
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the MIT License (MIT)
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *******************************************************************************/

package org.deetazilla.app

import java.util.Properties;
import java.io.File

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.streaming.Duration
import org.apache.spark.streaming.StreamingContext
import org.apache.spark.storage.StorageLevel;
import io.nats.client.Nats._
//import io.nats.client.Constants.PROP_URL

import org.apache.log4j.{Level, LogManager, PropertyConfigurator}

import com.logimethods.connector.nats.to_spark._
import com.logimethods.scala.connector.spark.to_nats._


object SparkProcessor extends App {

  val inputSubject = args(0)
  val inputStreaming = inputSubject.toUpperCase.contains("STREAMING")
  val outputSubject = args(1)
  val outputStreaming = outputSubject.toUpperCase.contains("STREAMING")
  println("Will process messages from " + inputSubject + " to " + outputSubject)

  val targets = scala.util.Properties.envOrElse("TARGETS", "DEFAULT")
  println("TARGETS = " + targets)

  val cassandraUrl = System.getenv("CASSANDRA_URL")
  println("CASSANDRA_URL = " + cassandraUrl)

  val conf = new SparkConf()
                .setAppName(args(2))
                .set("spark.cassandra.connection.host", cassandraUrl);
  val sc = new SparkContext(conf);
  val ssc = new StreamingContext(sc, new Duration(2000));

  println("===================== v20")

  val properties = new Properties();
  val natsUrl = System.getenv("NATS_URI")
  println("NATS_URI = " + natsUrl)
  properties.put("servers", natsUrl)
  properties.put(PROP_URL, natsUrl)

  val clusterId = System.getenv("NATS_CLUSTER_ID")

  val messages =
    if (inputStreaming) {
      NatsToSparkConnector
        .receiveFromNatsStreaming(classOf[java.lang.Float], StorageLevel.MEMORY_ONLY, clusterId)
        .withNatsURL(natsUrl)
        .withSubjects(inputSubject)
        .asStreamOf(ssc)
    } else {
      NatsToSparkConnector
        .receiveFromNats(classOf[java.lang.Float], StorageLevel.MEMORY_ONLY)
        .withProperties(properties)
        .withSubjects(inputSubject)
        .asStreamOf(ssc)
    }

  if (targets.contains("MESSAGES")) {
    println(">>> MESSAGES")
    messages.count.print()
    messages.map(_.toString).print()
  }

  val max = messages.reduce(Math.max(_,_))

  if (targets.contains("MAX")) {
    println(">>> MAX")
    max.map(_.toString).print()
  }

  if (targets.contains("CASSANDRA")) {
    max.saveToCassandra("smartmeter", "max_voltage")
  }

  if (outputStreaming) {
    SparkToNatsConnectorPool.newStreamingPool(clusterId)
                            .withNatsURL(natsUrl)
                            .withSubjects(outputSubject)
                            .publishToNats(max)
  } else {
    SparkToNatsConnectorPool.newPool()
                            .withProperties(properties)
                            .withSubjects(outputSubject)
                            .publishToNats(max)
  }

  ssc.start();

  ssc.awaitTermination()
}