terraform {
  backend "s3" {
    bucket         = "824622998597-tfstate"
    key            = "03-apprunner/terraform.tfstate.json"
    region         = "us-east-2"
    dynamodb_table = "824622998597-tflock"
    encrypt        = true
  }
}
