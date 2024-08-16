variable "ec2-ami-id" {
  description = "This holds the value for EC2 instance AMI ID"
}

variable "ec2-instance-type" {
  description = "This holds the value for EC2 instance type to be used"
}

variable "ec2-key-name" {
  description = "This holds the key name to be attached with EC2"
}

variable "subnet-id" {
  description = "This holds the value for subnet ID"
}

variable "tags" {
  description = "This holds the value for tags to be attached with EC2"
  type = map(string)
}