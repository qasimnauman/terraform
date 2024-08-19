resource "aws_lb" "web-alb" {
  name = "Web-tier-ALB"
  internal = false
  load_balancer_type = "application"

  security_groups = [ aws_security_group.web-tier-alb-sg.id ]
  subnets = [ aws_subnet.public-sub1-1a.id, aws_subnet.public-sub2-1b.id ]

  tags = {
    env = "web-alb"
  }
}

resource "aws_lb_target_group" "web-tg" {
  name = "web-tier-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    interval = 30
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 10
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "web-alb-listenner" {
  load_balancer_arn = aws_lb.web-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_autoscaling_attachment" "web-asg-attach" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.name
  lb_target_group_arn = aws_lb_target_group.web-tg.arn
}

# App tier load balancer
resource "aws_lb" "app-alb" {
  name = "App-tier-ALB"
  internal = false
  load_balancer_type = "application"

  security_groups = [ aws_security_group.app-tier-alb-sg.id ]
  subnets = [ aws_subnet.private-sub1-1a.id, aws_subnet.private-sub2-1a.id ]

  tags = {
    env = "app-alb"
  }
}

resource "aws_lb_target_group" "app-alb-tg" {
  name = "App-tier-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    interval = 30
    path = "/"
    port = "traffic-port"
    timeout = 10
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "app-alb-listenner" {
  load_balancer_arn = aws_lb.app-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app-alb-tg.arn
  }
}

resource "aws_autoscaling_attachment" "app-asg-attach" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  lb_target_group_arn = aws_lb.app-alb.arn
}