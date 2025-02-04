resource "aws_subnet" "firewall" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_firewall_cidr


  tags = {
    Name = "firewall-subnet"
  }
}

resource "aws_subnet" "customer1" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_customer_1_cidr


  tags = {
    Name = "customer1-subnet"
  }
}

resource "aws_subnet" "customer2" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_customer_2_cidr


  tags = {
    Name = "customer2-subnet"
  }
}

resource "aws_subnet" "customer3" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_customer_3_cidr


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

resource "aws_networkfirewall_rule_group" "stateful_group" {
  capacity = var.firewall_rule_group_capacity
  name     = var.firewall_rule_group_name
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
          direction        = "ANY"
          destination      = "ANY"
          destination_port = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
      stateful_rule {
        action = "PASS"
        header {
          protocol         = "TCP"
          source           = "10.0.1.0/24"
          source_port      = "ANY"
          direction        = "ANY"
          destination      = "ANY"
          destination_port = "80"
        }
        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }
      stateful_rule {
        action = "PASS"
        header {
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
          direction        = "ANY"
          destination      = "10.0.2.0/24"
          destination_port = "443"
        }
        rule_option {
          keyword  = "sid"
          settings = ["3"]
        }
      }
    }
  }
}

resource "aws_networkfirewall_firewall_policy" "example_policy" {
  name = var.firewall_policy_name
  firewall_policy {
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful_group.arn
    }
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
  }
}
