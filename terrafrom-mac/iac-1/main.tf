resource "aws_instance" "test-ec2" {
  ami = "ami-084568db4383264d4" # Ubuntu 22.04 AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "Testing Instance",
    Env = "Dev"
  }
  subnet_id = "subnet-0bbcfd476668b293b"
  key_name = "backend"
  associate_public_ip_address = true  # Assign a public IP address
}

output "arn" {
  value = aws_instance.test-ec2.arn
  description = "value for arn"
}

# terraform init
# terraform plan
# terraform apply