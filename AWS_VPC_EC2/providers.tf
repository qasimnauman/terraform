terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  alias = "us-east-1"
}

provider "aws" {
  region = "us-west-1"
  alias = "us-west-1"
}