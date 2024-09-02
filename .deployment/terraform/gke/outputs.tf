output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke.name
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.endpoint
}

output "gke_cluster_version" {
  description = "Kubernetes version of the GKE cluster"
  value       = module.gke.cluster_version
}

output "gke_node_pool_names" {
  description = "List of GKE node pool names"
  value       = module.gke.node_pools[*].name
}
