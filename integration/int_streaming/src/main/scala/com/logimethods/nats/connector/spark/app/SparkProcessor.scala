/*******************************************************************************
 * Copyright (c) 2016 Logimethods
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the MIT License (MIT)
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *******************************************************************************/

package com.logimethods.nats.connector.spark.app

import java.util.Properties;
import java.io.File

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.streaming.Duration
import org.apache.spark.streaming.StreamingContext
import org.apache.spark.storage.StorageLevel;
import io.nats.client.Nats._

import org.apache.log4j.{Level, LogManager, PropertyConfigurator}

import com.logimethods.connector.nats.to_spark._
import com.logimethods.scala.connector.spark.to_nats._

object SparkProcessor extends App {
  val log = LogManager.getRootLogger
  log.setLevel(Level.WARN)

  Thread.sleep(5000)

  val inputSubject = args(0)
  val inputStreaming = inputSubject.toUpperCase.contains("STREAMING")
  val outputSubject = args(1)
  val outputStreaming = outputSubject.toUpperCase.contains("STREAMING")
  println("Will process messages from " + inputSubject + " to " + outputSubject)

  val logLevel = scala.util.Properties.envOrElse("LOG_LEVEL", "INFO")
  println("LOG_LEVEL = " + logLevel)

  val sparkMasterUrl = System.getenv("SPARK_MASTER_URL")
  println("SPARK_MASTER_URL = " + sparkMasterUrl)
  val conf = new SparkConf().setAppName(args(2)).setMaster(sparkMasterUrl);
  val sc = new SparkContext(conf);
//  val jarFilesRegex = "java-nats-streaming-(.*)jar|guava(.*)jar|protobuf-java(.*)jar|jnats-(.*)jar|nats-connector-spark-(.*)jar|docker-nats-connector-spark(.*)jar"
  val jarFilesRegex = "(.*)jar"
  for (file <- new File("/app/").listFiles.filter(_.getName.matches(jarFilesRegex)))
    { sc.addJar(file.getAbsolutePath) }
  val ssc = new StreamingContext(sc, new Duration(2000));

  val properties = new Properties();
  val natsUrl = System.getenv("NATS_URI")
  println("NATS_URI = " + natsUrl)
  properties.put("servers", natsUrl)
  properties.put(PROP_URL, natsUrl)

  val clusterId = System.getenv("NATS_CLUSTER_ID")

  val messages =
    if (inputStreaming) {
      NatsToSparkConnector
        .receiveFromNatsStreaming(classOf[Float], StorageLevel.MEMORY_ONLY, clusterId)
        .withNatsURL(natsUrl)
        .withSubjects(inputSubject)
        .asStreamOf(ssc)
    } else {
      NatsToSparkConnector
        .receiveFromNats(classOf[Float], StorageLevel.MEMORY_ONLY)
        .withProperties(properties)
        .withSubjects(inputSubject)
        .asStreamOf(ssc)
    }

  if (logLevel.contains("MESSAGES")) {
    messages.print()
  }

  val max = messages.reduce(Math.max(_,_))

  if (logLevel.contains("MAX")) {
    max.print()
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