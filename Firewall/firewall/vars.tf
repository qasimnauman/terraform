variable "aws_vpc_id" {
  description = "The ID of the AWS VPC"
  type        = string
}

variable "aws_igw_id" {
  description = "The ID of the AWS Internet Gateway"
  type        = string
}

variable "aws_region" {
  description = "This is the region for AWS"
  type        = string
}

variable "aws_subnet_customer_1_cidr" {
  description = "This holds the value for the CIDR block customer for Subnet 1"
  type        = string
}

variable "aws_subnet_customer_2_cidr" {
  description = "This Holds the value for CIDR block for customer Subnet 2"
  type        = string
}
variable "aws_subnet_customer_3_cidr" {
  description = "This Holds the value for CIDR block for customer Subnet 3"
  type        = string
}

variable "aws_subnet_firewall_cidr" {
  description = "This Holds the value for CIDR block for firewall subnet"
  type        = string
}
