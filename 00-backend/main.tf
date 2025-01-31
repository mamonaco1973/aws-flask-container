provider "aws" {
  region = "us-east-2"
}

# Fetch AWS account ID dynamically
data "aws_caller_identity" "current" {}

# Construct unique bucket name using account ID
locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}-tfstate"
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB Table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "${data.aws_caller_identity.current.account_id}-tflock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Generate 01-ecr-backend.tf.template file dynamically
resource "local_file" "backend_config_ecr" {
  filename = "../01-ecr/01-ecr-backend.tf"
  content  = <<EOT
terraform {
  backend "s3" {
    bucket         = "${local.bucket_name}"
    key            = "01-ecr/terraform.tfstate.json"
    region         = "us-east-2"
    dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
    encrypt        = true
  }
}
EOT
}


# Generate 03-apprunner-backend.tf.template file dynamically
resource "local_file" "backend_config_apprunner" {
  filename = "../03-apprunner/03-apprunner-backend.tf"
  content  = <<EOT
terraform {
  backend "s3" {
    bucket         = "${local.bucket_name}"
    key            = "03-apprunner/terraform.tfstate.json"
    region         = "us-east-2"
    dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
    encrypt        = true
  }
}
EOT
}
