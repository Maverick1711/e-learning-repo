terraform {
  backend "s3" {
    bucket = "elearning-backend"
    key    = "terraform.tfstate"
    region = "var.region"
    dynamodb_table = "elearningdynamo"
  }
}
