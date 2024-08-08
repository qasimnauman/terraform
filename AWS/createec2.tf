 provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "testing" {
  ami = "ami-04a81a99f5ec58529" # Ubuntu 22.04 AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "Testing Instance"
  }
  subnet_id = "subnet-059058ec54f2444ea"
  key_name = "webiode-key"
  associate_public_ip_address = true  # Assign a public IP address
}