provider "aws" {
  alias = "no1"
  region = "us-east-1"
}

resource "aws_instance" "multi-region-1" {
  ami = "ami-04a81a99f5ec58529" # Ubuntu 22.04 AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = var.tagname
    Env= var.environment
  }
  subnet_id = "subnet-059058ec54f2444ea"
  key_name = "webiode-key"
  provider = aws.no1
}

output "publicip" {
  value = aws_instance.multi-region-1.public_ip
}