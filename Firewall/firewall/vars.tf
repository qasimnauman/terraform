variable "aws_vpc_id" {
    description = "The ID of the AWS VPC"
    type        = string
}

variable "aws_igw_id" {
    description = "The ID of the AWS Internet Gateway"
    type        = string
}

variable "aws_region"{
    description = "This is the region for AWS"
    type = string
}

variable "subnets" {
  description = "A map of subnets"
  type = map(object({
    cidr_block              = string
    map_public_ip_on_launch = bool
    name                    = string
  }))
}