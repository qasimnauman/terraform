# resource "aws_subnet" "firewall" {
#   vpc_id                  = var.aws_vpc_id
#   cidr_block              = "10.0.4.0/28"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "firewall-subnet"
#   }
# }

# resource "aws_subnet" "customer1" {
#   vpc_id                  = var.aws_vpc_id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "customer1-subnet"
#   }
# }

# resource "aws_subnet" "customer2" {
#   vpc_id                  = var.aws_vpc_id
#   cidr_block              = "10.0.3.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "customer2-subnet"
#   }
# }

# resource "aws_subnet" "customer3" {
#   vpc_id                  = var.aws_vpc_id
#   cidr_block              = "10.0.5.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "customer3-subnet"
#   }
# }

# resource "aws_route_table" "firewall" {
#   vpc_id = var.aws_vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = var.aws_igw_id
#   }

#   tags = {
#     Name = "firewall-route-table"
#   }
# }

# resource "aws_route_table_association" "firewall" {
#   subnet_id      = aws_subnet.firewall.id
#   route_table_id = aws_route_table.firewall.id
# }

# resource "aws_route_table_association" "customer1" {
#   subnet_id      = aws_subnet.customer1.id
#   route_table_id = aws_route_table.firewall.id
# }

# resource "aws_route_table_association" "customer2" {
#   subnet_id      = aws_subnet.customer2.id
#   route_table_id = aws_route_table.firewall.id
# }

# resource "aws_route_table_association" "customer3" {
#   subnet_id      = aws_subnet.customer3.id
#   route_table_id = aws_route_table.firewall.id
# }

# resource "aws_security_group" "firewall" {
#   name        = "firewall-sg"
#   description = "Security group for firewall"
#   vpc_id      = var.aws_vpc_id

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "firewall-security-group"
#   }
# }

# resource "aws_security_group" "customer" {
#   name        = "customer-sg"
#   description = "Security group for customer"
#   vpc_id      = var.aws_vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "customer-security-group"
#   }
# }

resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = var.aws_vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table" "firewall" {
  vpc_id = var.aws_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.aws_igw_id
  }

  tags = {
    Name = "firewall-route-table"
  }
}

resource "aws_route_table_association" "subnet_associations" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_security_group" "firewall" {
  name        = "firewall-sg"
  description = "Security group for firewall"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "firewall-security-group"
  }
}

resource "aws_security_group" "customer" {
  name        = "customer-sg"
  description = "Security group for customers"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "customer-security-group"
  }
}
