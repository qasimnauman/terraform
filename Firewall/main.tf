module "firewall" {
  source                     = "./firewall"
  aws_region                 = "us-east-1"
  aws_vpc_id                 = "vpc-xxx"
  aws_igw_id                 = "igw-xxxx"
  aws_subnet_customer_1_cidr = "172.31.5.0/24"
  aws_subnet_customer_2_cidr = "172.31.2.0/24"
  aws_subnet_customer_3_cidr = "172.31.3.0/24"
  aws_subnet_firewall_cidr   = "172.31.4.0/24"
}

output "customer1_subnet_id" {
  description = "IDs of the created subnets"
  value       = module.firewall.customer1_subnet_id
}
output "customer2_subnet_id" {
  description = "IDs of the created subnets"
  value       = module.firewall.customer2_subnet_id
}
output "customer3_subnet_id" {
  description = "IDs of the created subnets"
  value       = module.firewall.customer3_subnet_id
}

output "route_table_id" {
  description = "ID of the firewall route table"
  value       = module.firewall.route_table_id
}

output "security_group_firewall" {
  description = "Firewall security group ID"
  value       = module.firewall.security_group_firewall
}

output "security_group_customer" {
  description = "Customer security group ID"
  value       = module.firewall.security_group_customer
}
