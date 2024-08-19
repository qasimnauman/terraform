terraform {
  backend "s3" {
    bucket = "qasimnauman-tf-bucket"
    key = "qasim/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}