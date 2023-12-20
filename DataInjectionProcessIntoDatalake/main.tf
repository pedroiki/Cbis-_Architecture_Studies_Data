# This Terraform code sets up an AWS infrastructure for an ingestion pipeline.

# Create an S3 bucket for the ingestion pipeline
module "ingestion-pipeline" {
  source        = "hashicorp/aws/modules/s3-bucket"
  name          = "ingestion-pipeline"
  region        = var.region
  acl           = "private"
  force_destroy = true

  # Tags for better organization
  tags = {
    Name        = "Ingestion Pipeline"
    Environment = var.environment
  }

  # Ensure the bucket is created before being destroyed
  lifecycle {
    create_before_destroy = true
  }
}

# Set up an RDS MySQL database as the source for the ingestion pipeline
module "mysql-source" {
  source     = "hashicorp/aws/modules/rds-mysql"
  name       = "ingestion-pipeline-source"
  region     = var.region
  instance_type = "t2.micro"
  db_name    = "ingestion-pipeline"
  db_user    = "ingestion-pipeline"
  db_password = "password"

  # Tags for better organization
  tags = {
    Name        = "Ingestion Pipeline Source"
    Environment = var.environment
  }
}

# Create an AWS Lambda function for the ingestion job
module "ingestion-job" {
  source           = "hashicorp/aws/modules/lambda"
  name             = "ingestion-pipeline-job"
  region           = var.region
  handler          = "ingestion-pipeline.lambda_handler"
  runtime          = "python3.8"
  timeout          = 300
  source_code_hash = data.archive_file.ingestion_pipeline_code.output_base64sha256

  # Use the RDS MySQL endpoint as the event source
  event_source_arn = module.mysql-source.rds_endpoint_address
  event_bus_name   = "default"

  # Tags for better organization
  tags = {
    Name        = "Ingestion Pipeline Job"
    Environment = var.environment
  }
}

# Set up permissions for the Lambda function to be invoked by an AWS Event
resource "aws_lambda_permission" "ingestion-pipeline" {
  action        = "lambda:InvokeFunction"
  function_name = module.ingestion-job.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:eu-west-1:123456789012:rule/ingestion-pipeline"
}

# Create an AWS CloudWatch Event Rule for scheduling the ingestion pipeline
resource "aws_cloudwatch_event_rule" "ingestion-pipeline" {
  name                = "ingestion-pipeline"
  description         = "Ingestion pipeline"
  schedule_expression = "cron(0/5 * * * ? *)"  # Run every 5 minutes

  # Tags for better organization
  tags = {
    Name        = "Ingestion Pipeline Rule"
    Environment = var.environment
  }
}
