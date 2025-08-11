output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.main[*].id
}

output "instance_arns" {
  description = "ARNs of the EC2 instances"
  value       = aws_instance.main[*].arn
}

output "public_ips" {
  description = "Public IP addresses of the instances"
  value       = aws_instance.main[*].public_ip
}

output "private_ips" {
  description = "Private IP addresses of the instances"
  value       = aws_instance.main[*].private_ip
}

output "public_dns" {
  description = "Public DNS names of the instances"
  value       = aws_instance.main[*].public_dns
}

output "private_dns" {
  description = "Private DNS names of the instances"
  value       = aws_instance.main[*].private_dns
}