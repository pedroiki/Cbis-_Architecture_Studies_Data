# Module to create an AWS S3 Data Lake

# Set up the data lake module from the specified source
module "data-lake" {
  source = "hashicorp/aws/modules/data-lake"

  # Name and region for the data lake
  name   = "data-lake"
  region = var.region

  # Configuration for the S3 bucket
  bucket_name = "my-data-lake"
  bucket_acl  = "private"

  # Use the IAM policy document defined below for the S3 bucket
  s3_policy_document = data.aws_iam_policy_document.data_lake_policy.json

  # Tags for better organization and identification
  tags = {
    Name        = "Data Lake"
    Environment = var.environment
  }
}

# Define IAM policy document for the data lake

# This data block specifies the IAM policy for the data lake
data "aws_iam_policy_document" "data_lake_policy" {
  # Allow GetObject and PutObject actions on objects within the S3 bucket
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::my-data-lake/*"]
  }

  # Allow ListBucket action on the S3 bucket itself
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::my-data-lake"]
  }

  # Set a name for the IAM policy
  policy_name = "data-lake-policy"
}
