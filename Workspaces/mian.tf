module "S3-Bucket" {
  source = "./modules/s3_bucket"
  bucketname = lookup(var.bucketname, terraform.workspace, var.bucketname["dev"])
}

variable "bucketname" {
  type = map(string)
  description = "The name of the S3 bucket"

  default = {
    "dev" = "my-dev-bucket"
    "prod" = "my-prod-bucket"
    "stage" = "my-stage-bucket"
  }
}