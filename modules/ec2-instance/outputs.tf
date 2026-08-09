output "id" {
  description = "ID of the instance."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.this.private_ip
}

output "private_dns" {
  description = "Private DNS name of the instance."
  value       = aws_instance.this.private_dns
}
