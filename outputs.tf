output "vpc_id" {
  description = "ID of the cluster VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = aws_subnet.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway serving the private subnet."
  value       = aws_nat_gateway.main.id
}

output "nat_eip_public_ip" {
  description = "Public IP address of the NAT gateway's Elastic IP."
  value       = aws_eip.nat.public_ip
}

output "master_private_ips" {
  description = "Map of control-plane node name to its static private IP."
  value       = { for k, m in module.master : k => m.private_ip }
}

output "master_instance_ids" {
  description = "Map of control-plane node name to its EC2 instance ID."
  value       = { for k, m in module.master : k => m.id }
}
