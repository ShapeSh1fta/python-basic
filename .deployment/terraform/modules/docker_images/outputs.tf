# Output for AWS ECR
output "ecr_repository_url" {
  description = "The URL of the ECR repository in AWS"
  value       = aws_ecr_repository.docker_repository[0].repository_url
  condition   = var.provider == "eks"
}

# Output for GCP GCR
output "gcr_registry_url" {
  description = "The URL of the GCR repository in GCP"
  value       = "gcr.io/${var.gcp_gcr_project_id}/${var.docker_image_name}:${var.docker_image_tag}"
  condition   = var.provider == "gke"
}
