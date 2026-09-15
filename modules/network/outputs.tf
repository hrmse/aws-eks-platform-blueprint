output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC identifier for cluster and supporting services."
}

output "private_subnet_ids" {
  value       = values(aws_subnet.private)[*].id
  description = "Private subnet identifiers, one in each selected AZ."
}

output "endpoint_security_group_id" {
  value       = aws_security_group.endpoints.id
  description = "Security group attached to interface endpoints."
}
