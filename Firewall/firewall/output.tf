output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = { for k, v in aws_subnet.subnets : k => v.id }
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
