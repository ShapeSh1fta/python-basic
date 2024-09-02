# Output from provider-specific modules
output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = module.provider_specific.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = module.provider_specific.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the cluster"
  value       = module.provider_specific.cluster_version
}

output "node_group_names" {
  description = "List of node group or node pool names"
  value       = module.provider_specific.node_group_names
}

# Shared Outputs

output "docker_image_url"  {
  description = "The URL of the Docker image in the container registry"
  value       = module.docker_images.ecr_repository_url != "" ? module.docker_images.ecr_repository_url : module.docker_images.gcr_registry_url
}

output "storage_bucket_name" {
  description = "The name of the storage bucket"
  value = module.storage.s3_bucket_name != "" ? module.storage.s3_bucket_name : module.storage.gcs_bucket_name
}

output "secrets" {
  description = "Secret values used in Kubernetes"
  value = module.secret_storage.example_secret_arn != "" ? module.secret_storage.example_secret_arn : module.secret_storage.example_secret_id
}

output "argocd_server_url" {
  description = "The URL of the ArgoCD server"
  value       = helm_release.argocd.status[*].url[0]
}
