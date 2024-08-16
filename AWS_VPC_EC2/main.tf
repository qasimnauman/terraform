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
  user_data = base64encode(file("userdata.sh"))
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
  user_data = base64encode(file("userdata.sh"))
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
  port = 82
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
  port = 82
}

resource "aws_lb_target_group_attachment" "tgattach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webserver2.id
  port = 82
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.mylb.arn
  port = 82
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