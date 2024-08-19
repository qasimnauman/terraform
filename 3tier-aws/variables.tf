variable "aws-region" {
  description = "Region for AWS"
}

variable "azs" {
  description = "Availability Zones for VPC"
  type = list(string)
}

variable "vpc-cidr-block" {
  description = "CIDR block for VPC"
}

variable "vpc_name" {
  description = "Name for VPC"
}

variable "ami-id" {
  description = "AMI-ID for Instances"
}

variable "ec2-instance-type" {
  description = "Value of instance type"
}