output "customer1_subnet_id" {
  description = "IDs of the created subnets"
  value       = aws_route_table_association.customer1.id
}
output "customer2_subnet_id" {
  description = "IDs of the created subnets"
  value       = aws_route_table_association.customer2.id
}
output "customer3_subnet_id" {
  description = "IDs of the created subnets"
  value       = aws_route_table_association.customer3.id
}

output "route_table_id" {
  description = "ID of the firewall route table"
  value       = aws_route_table.firewall.id
}

output "security_group_firewall" {
  description = "Firewall security group ID"
  value       = aws_security_group.firewall.id
}

output "security_group_customer" {
  description = "Customer security group ID"
  value       = aws_security_group.customer.id
}
