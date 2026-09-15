output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "private_subnet_ids" { value = module.network.private_subnet_ids }
