import org.apache.spark.sql.SparkSession

object SparkDataAnalysis {

  def main(args: Array[String]): Unit = {

    // Create a Spark session
    val spark = SparkSession.builder.appName("Spark Data Analysis").getOrCreate()

    // Read the data from the Parquet file
    val df = spark.read.parquet("my-data-lake/data.parquet")

    // Perform analysis
    df.describe().show()

    // Generate a report
    df.write.mode("overwrite").parquet("my-data-lake/report.parquet")
  }
}