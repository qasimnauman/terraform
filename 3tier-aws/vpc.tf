resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc-cidr-block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public-sub1-1a" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = element(var.azs,0)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub1-1a"
    tier = "Webserver"
  }
}

resource "aws_subnet" "public-sub2-1b" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.16.0/20"
  availability_zone = element(var.azs,1)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub1-1b"
    tier = "Webserver"
  }
}

# Private Subnets
resource "aws_subnet" "private-sub1-1a" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.128.0/20"
  availability_zone = element(var.azs,0)
  tags = {
    Name = "private-sub1-1a"
    tier = "Application"
  }
}

resource "aws_subnet" "private-sub2-1a" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.144.0/20"
  availability_zone = element(var.azs,0)
  tags = {
    Name = "private-sub2-1a"
    tier = "Application"
  }
}

resource "aws_subnet" "private-sub1-1b" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.160.0/20"
  availability_zone = element(var.azs,1)
  tags = {
    Name = "private-sub1-1b"
    tier = "DB"
  }
}

resource "aws_subnet" "private-sub2-1b" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.176.0/20"
  availability_zone = element(var.azs,1)
  tags = {
    Name = "private-sub2-1b"
    tier = "DB"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "3-tier-vpc-igw"
  }
}

# Elastic IP
resource "aws_eip" "my_eip" {
    domain = "vpc"
  tags = {
    Name = "MyElasticIP"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "three-tier-igw-nat" {
  subnet_id = aws_subnet.public-sub1-1a.id
  allocation_id = aws_eip.my_eip.id

  tags = {
    Name = "3-tier-igw-nat"
  }
}

# Route Tables
resource "aws_route_table" "web-rtb" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "web-rtb"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "app-rtb" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "app-rtb"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.three-tier-igw-nat.id
  }
}

# Public Subnets and Web route table association
resource "aws_route_table_association" "web-as1" {
  route_table_id = aws_route_table.web-rtb.id
  subnet_id = aws_subnet.public-sub1-1a.id
}

resource "aws_route_table_association" "web-as2" {
  route_table_id = aws_route_table.web-rtb.id
  subnet_id = aws_subnet.public-sub2-1b.id
}

# Private subnets and app route table association
resource "aws_route_table_association" "app-as1" {
  route_table_id = aws_route_table.app-rtb.id
  subnet_id = aws_subnet.private-sub1-1a.id
}

resource "aws_route_table_association" "app-as2" {
  route_table_id = aws_route_table.app-rtb.id
  subnet_id = aws_subnet.private-sub1-1b.id
}

resource "aws_route_table_association" "app-as3" {
  route_table_id = aws_route_table.app-rtb.id
  subnet_id = aws_subnet.private-sub2-1a.id
}

resource "aws_route_table_association" "app-as4" {
  route_table_id = aws_route_table.app-rtb.id
  subnet_id = aws_subnet.private-sub2-1b.id
}