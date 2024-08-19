# resource "aws_security_group" "newsg" {
#   name = "newsg"
#   vpc_id = aws_vpc.myvpc.id
  
#   tags = {
#     Name = "newsg"
#   }
# }

# resource "aws_security_group_rule" "ssh_allow" {
#   security_group_id = aws_security_group.newsg.id
#   protocol = "tcp"
#   from_port = 22
#   to_port = 22
#   cidr_blocks = [ "0.0.0.0/0" ]
#   type = "ingress"
# }

# resource "aws_security_group_rule" "http_allow" {
#   security_group_id = aws_security_group.newsg.id
#   from_port = 80
#   to_port = 80
#   protocol = "tcp"
#   type = "ingress"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }

# resource "aws_security_group_rule" "http_allow_81" {
#   security_group_id = aws_security_group.newsg.id
#   from_port = 81
#   to_port = 81
#   protocol = "tcp"
#   type = "ingress"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }

# resource "aws_security_group_rule" "allow_all" {
#   security_group_id = aws_security_group.newsg.id
#   from_port = 0
#   to_port = 0
#   protocol = "-1"
#   type = "ingress"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }

# resource "aws_security_group_rule" "allows_all_egress" {
#   security_group_id = aws_security_group.newsg.id
#   type = "egress"
#   from_port = 0
#   to_port = 0
#   protocol = "-1"
#   cidr_blocks = [ "0.0.0.0/0" ]
# }
