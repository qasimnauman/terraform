resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "testvpc_terraform"
  }
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "testsubnet1_terraform"
  }
  # for making the subnet private and public
  # true means public and false means private
  map_public_ip_on_launch = true 
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "testsubnet2_terraform"
  }

  # for making the subnet private and public
  # true means public and false means private
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "test-route-table"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "rta2" {
  route_table_id = aws_route_table.rt1.id
  subnet_id = aws_subnet.subnet2.id
}

resource "aws_security_group" "newsg" {
  name = "newsg"
  vpc_id = aws_vpc.myvpc.id
  
  tags = {
    Name = "newsg"
  }
}

resource "aws_security_group_rule" "ssh_allow" {
  security_group_id = aws_security_group.newsg.id
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = [ "0.0.0.0/0" ]
  type = "ingress"
}

resource "aws_security_group_rule" "http_allow" {
  security_group_id = aws_security_group.newsg.id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  type = "ingress"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "http_allow_81" {
  security_group_id = aws_security_group.newsg.id
  from_port = 81
  to_port = 81
  protocol = "tcp"
  type = "ingress"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "allow_all" {
  security_group_id = aws_security_group.newsg.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  type = "ingress"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "allows_all_egress" {
  security_group_id = aws_security_group.newsg.id
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "qasimnauman"
}

resource "aws_instance" "webserver1" {
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
  key_name = "webiode-key"
  vpc_security_group_ids = [aws_security_group.newsg.id]
  user_data = base64encode(file("ng.sh"))
  tags = {
    Name="Webserver1"
  }
  # associate_public_ip_address = true
}

resource "aws_instance" "webserver2" {
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet2.id
  key_name = "webiode-key"
  vpc_security_group_ids = [aws_security_group.newsg.id]
  user_data = base64encode(file("ng2.sh"))
  tags = {
    Name = "webserver2"
  }
}

resource "aws_lb" "mylb" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"

  security_groups = [ aws_security_group.newsg.id ]
  subnets = [ aws_subnet.subnet1.id, aws_subnet.subnet2.id ]

  tags = {
    Name = "web"
  }
}

resource "aws_lb_target_group" "tg" {
  name = "myTG"
  port = 81
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "tgattach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webserver1.id
  port = 81
}

resource "aws_lb_target_group_attachment" "tgattach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webserver2.id
  port = 81
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.mylb.arn
  port = 81
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "out-val" {
  value = {
    alb_dns_name = aws_lb.mylb.dns_name
    ec2_public_ip_1 = aws_instance.webserver1.public_ip
    ec2_public_ip_2 = aws_instance.webserver2.public_ip
    vpc_id = aws_vpc.myvpc.id
    subnet1_id = aws_subnet.subnet1.id
  }
}