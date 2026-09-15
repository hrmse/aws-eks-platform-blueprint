output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS cluster name."
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "Private Kubernetes API endpoint."
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Base64-encoded cluster CA; treat as configuration data."
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description = "AWS-managed control plane security group."
}
