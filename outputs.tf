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

output "worker_private_ips" {
  description = "Map of worker node name to its static private IP."
  value       = { for k, w in module.worker : k => w.private_ip }
}

output "worker_instance_ids" {
  description = "Map of worker node name to its EC2 instance ID."
  value       = { for k, w in module.worker : k => w.id }
}

# Future kube-apiserver endpoint: use this DNS name in kubeconfigs and as
# kubeadm's controlPlaneEndpoint.
output "api_nlb_dns_name" {
  description = "DNS name of the internal NLB fronting the Kubernetes API server."
  value       = aws_lb.api.dns_name
}

# Stable control-plane name: use this (not the raw NLB DNS name) as kubeadm's
# controlPlaneEndpoint and in kubeconfigs — it survives NLB recreation.
output "control_plane_endpoint" {
  description = "Stable private DNS name of the Kubernetes API server endpoint."
  value       = aws_route53_record.control_plane.fqdn
}
