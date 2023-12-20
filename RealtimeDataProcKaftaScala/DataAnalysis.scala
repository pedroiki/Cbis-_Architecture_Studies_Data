import org.apache.kafka.clients.consumer.ConsumerRecord
import org.apache.kafka.clients.consumer.KafkaConsumer

object ScalaKafkaConsumer {

  def main(args: Array[String]): Unit = {

    // Create a Kafka consumer
    val consumer = new KafkaConsumer[String, String](
      Map(
        "bootstrap.servers" -> "localhost:9092",
        "key.deserializer" -> classOf[org.apache.kafka.common.serialization.StringDeserializer],
        "value.deserializer" -> classOf[org.apache.kafka.common.serialization.StringDeserializer]
      )
    )

    // Subscribe to the topic
    consumer.subscribe(List("my-topic"))

    // Consume records
    while (true) {
      val records = consumer.poll(100)

      for (record <- records) {
        // Process the record
        println(record)
      }
    }