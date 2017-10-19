/*******************************************************************************
 * Copyright (c) 2016 Logimethods
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the MIT License (MIT)
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *******************************************************************************/

package com.logimethods.nats.connector.spark.app

import java.util.Properties
import org.nats._

// @see https://github.com/tyagihas/scala_nats
object DummyNatsTransmiter extends App {
  val properties = new Properties()
  val natsUrl = System.getenv("NATS_URI")
  println("NATS_URI = " + natsUrl)
  properties.put("servers", natsUrl)
  val conn = Conn.connect(properties)

  val inputSubject = args(0)
  val outputSubject = args(1)
  println("Will transmit messages from " + inputSubject + " to " + outputSubject)

  conn.subscribe(inputSubject, (msg:MsgB) => {
    import java.nio.ByteBuffer
    val buffer = ByteBuffer.wrap(msg.body)
    val value = new java.lang.Float(buffer.getFloat())
    println("Transmiting message from " + inputSubject + " to " + outputSubject + ": " + value)
    conn.publish(outputSubject, value.toString)
    })
}