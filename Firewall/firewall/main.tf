resource "aws_subnet" "firewall" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.aws_subnet_firewall_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "firewall-subnet"
  }
}

resource "aws_subnet" "customer1" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.aws_subnet_customer_1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "customer1-subnet"
  }
}

resource "aws_subnet" "customer2" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.aws_subnet_customer_2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "customer2-subnet"
  }
}

resource "aws_subnet" "customer3" {
  vpc_id                  = var.aws_vpc_id
  cidr_block              = var.aws_subnet_customer_3_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "customer3-subnet"
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

resource "aws_route_table_association" "firewall" {
  subnet_id      = aws_subnet.firewall.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table_association" "customer1" {
  subnet_id      = aws_subnet.customer1.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table_association" "customer2" {
  subnet_id      = aws_subnet.customer2.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table_association" "customer3" {
  subnet_id      = aws_subnet.customer3.id
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
  description = "Security group for customer"
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
