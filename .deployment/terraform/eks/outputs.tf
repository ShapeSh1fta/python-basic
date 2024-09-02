output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "eks_node_group_names" {
  description = "List of EKS node group names"
  value       = module.eks.node_groups
}
