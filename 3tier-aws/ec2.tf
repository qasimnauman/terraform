resource "aws_launch_configuration" "web-config" {
  name = "three-tier-web-config"
  image_id = var.ami-id
  instance_type = var.ec2-instance-type
  key_name = "web-key"
  security_groups = [ aws_security_group.web-tier-sg.id ]
  user_data = base64encode("web-userdata.sh")
  associate_public_ip_address = true
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_launch_configuration" "app-config" {
  image_id = var.ami-id
  instance_type = var.ec2-instance-type
  key_name = "app-key"
  security_groups = [ aws_security_group.app-tier-sg.id ]
  user_data = base64encode("app-userdata.sh")
  associate_public_ip_address = true
  lifecycle {
    ignore_changes = all
  }
}

# Auto scalling groups
resource "aws_autoscaling_group" "web-asg" {
    name = "Web tier ASG"
    launch_configuration = aws_launch_configuration.web-config.id
    vpc_zone_identifier = [ aws_subnet.public-sub1-1a.id, aws_subnet.public-sub2-1b.id ]
    min_size = 1
    max_size = 2
    desired_capacity = 1
}

resource "aws_autoscaling_group" "app-asg" {
    name = "App tier ASG"
    launch_configuration = aws_launch_configuration.app-config.id
    vpc_zone_identifier = [ aws_subnet.private-sub1-1a.id, aws_subnet.private-sub2-1a.id ]
    min_size = 1
    max_size = 2
    desired_capacity = 1
}