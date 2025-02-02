module "firewall" {
  source = "./firewall"
  aws_region = "us-east-1"
  aws_vpc_id = "vpc-xxxxxxx"
  aws_igw_id = "igw-xxxxxx"

  subnets = {
    firewall = {
      cidr_block              = "10.0.4.0/28"
      map_public_ip_on_launch = true
      name                    = "firewall-subnet"
    }
    customer1 = {
      cidr_block              = "10.0.2.0/24"
      map_public_ip_on_launch = true
      name                    = "customer1-subnet"
    }
    customer2 = {
      cidr_block              = "10.0.3.0/24"
      map_public_ip_on_launch = true
      name                    = "customer2-subnet"
    }
    customer3 = {
      cidr_block              = "10.0.5.0/24"
      map_public_ip_on_launch = true
      name                    = "customer3-subnet"
    }
  }
}
