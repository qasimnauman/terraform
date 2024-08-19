# resource "aws_vpc" "myvpc" {
#   cidr_block = var.cidr-block
#   tags = {
#     Name = "testvpc_terraform"
#   }
#   enable_dns_hostnames = true
# }

# resource "aws_subnet" "subnet1" {
#   vpc_id = aws_vpc.myvpc.id
#   cidr_block = "10.0.0.0/24"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "testsubnet1_terraform"
#   }
#   # for making the subnet private and public
#   # true means public and false means private
#   map_public_ip_on_launch = true 
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id = aws_vpc.myvpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-east-1b"
#   tags = {
#     Name = "testsubnet2_terraform"
#   }

#   # for making the subnet private and public
#   # true means public and false means private
#   map_public_ip_on_launch = true
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id
# }

# resource "aws_route_table" "rt1" {
#   vpc_id = aws_vpc.myvpc.id
#   tags = {
#     Name = "test-route-table"
#   }

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# resource "aws_route_table_association" "rta1" {
#   route_table_id = aws_route_table.rt1.id
#   subnet_id = aws_subnet.subnet1.id
# }

# resource "aws_route_table_association" "rta2" {
#   route_table_id = aws_route_table.rt1.id
#   subnet_id = aws_subnet.subnet2.id
# }