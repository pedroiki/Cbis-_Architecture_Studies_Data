# Create an AWS S3 bucket and associated IAM policy

# Define an AWS S3 bucket with a specific name and access control level
resource "aws_s3_bucket" "example" {
  bucket = "my-data-lake"
  acl    = "private"
}

# Define an IAM policy document for the S3 bucket
data "aws_iam_policy_document" "data-lake_policy" {
  # Specify actions and resources allowed by the policy
  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [aws_s3_bucket.example.arn + "/*"]
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.example.arn]
  }

  # Set a name for the IAM policy
  policy_name = "data-lake-policy"
}

# Output the JSON representation of the IAM policy document
output "iam_policy_json" {
  value = data.aws_iam_policy_document.data-lake_policy.json
}

# Additional metadata for tagging the AWS resources
resource "aws_s3_bucket" "example" {
  bucket = "my-data-lake"
  acl    = "private"
}

# Apply tags to the AWS resources for better organization
resource "aws_s3_bucket" "example" {
  bucket = "my-data-lake"
  acl    = "private"

  # Set tags for better resource organization
  tags = {
    Name        = "Data Lake"
    Environment = var.environment
  }
}
