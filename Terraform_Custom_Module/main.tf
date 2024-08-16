provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ec2-ami-id = "ami-0a0e5d9c7acc336f1"
    ec2-instance-type = "t2.micro"
    ec2-key-name = "weboidekey"
    subnet-id = "subnet-059058ec54f2444ea"
    tags = {
      "Name" = "Test"
    }
}

output "publicip" {
  value = module.ec2_instance.Public_IP
}