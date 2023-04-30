terraform {
  backend "s3" {
    bucket = "elearning-backend"
    key    = "terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}
