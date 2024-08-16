resource "aws_instance" "exp" {
  ami = var.ec2-ami-id
  instance_type = var.ec2-instance-type
  subnet_id = var.subnet-id
  key_name = var.ec2-key-name
  tags = var.tags
}