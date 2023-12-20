resource "aws_s3_bucket" "data-lake" {
  name = "my-data-lake"
  region = var.region

  acl = "private"
  force_destroy = true

  tags = {
    Name = "Data Lake"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  # Set the bucket policy to allow only authenticated users to access the data

  policy = data.aws_iam_policy_document.data_lake_policy.json

  # Enable versioning to support point-in-time recovery

  versioning {
    enabled = true
  }

  # Set the bucket to use the Parquet format

  object_lock_configuration {
    default_retention_period {
      days = 30
    }
  }
}