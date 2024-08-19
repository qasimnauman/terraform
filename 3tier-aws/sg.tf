resource "aws_security_group" "web-tier-sg" {
  name = "web-ec2-sg"
  description = "Allows traffic from VPC"
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "web-ec2-sg"
  }
  depends_on = [ aws_vpc.myvpc ]

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }

  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "-1"
  }
}

resource "aws_security_group" "app-tier-sg" {
  name = "app-tier-sg"
  description = "This allows traffic from web tier to app tier"
  vpc_id = aws_vpc.myvpc.id
  depends_on = [ aws_vpc.myvpc ]
  tags = {
    Name = "app-tier-sg"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    security_groups = [ aws_security_group.web-tier-sg.id ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.web-tier-sg.id ]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.web-tier-sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "db-tier-sg" {
  name = "db-tier-sg"
  description = "This allow traffic from app tier to db tier"
  vpc_id = aws_vpc.myvpc.id

  # ingress {
  #   from_port       = 3306
  #   to_port         = 3306
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.app-tier-sg.id]
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }
  
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [ "10.0.16.0/20", "10.0.128.0/20" ]
    description = "Allow access from app tier"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "10.0.0.0/16" ]
    security_groups = [ aws_security_group.app-tier-sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "web-tier-alb-sg" {
  name = "web-tier-sg"
  description = "SG for load balancer of Web tier"
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "web-tier-sg"
  }
  depends_on = [ 
    aws_vpc.myvpc
   ]

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "app-tier-alb-sg" {
  name = "app-tier-sg"
  description = "SG for load balancer of app tier"
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "app-tier-sg"
  }
  depends_on = [ 
    aws_vpc.myvpc
   ]

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [ aws_security_group.web-tier-sg.id ]
  }
}

