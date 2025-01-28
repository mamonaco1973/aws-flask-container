
provider "aws" {
  region = "us-east-2" # Default region set to US East (Ohio). Modify if your deployment requires another region.
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
