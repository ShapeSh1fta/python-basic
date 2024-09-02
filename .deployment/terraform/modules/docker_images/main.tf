# AWS ECR Configuration
resource "aws_ecr_repository" "docker_repository" {
  count = var.provider == "eks" ? 1 : 0

  name = var.aws_ecr_repository_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.docker_repository[0].repository_url
  condition = var.provider == "eks"
}

# GCP GCR Configuration
output "gcr_registry_url" {
  value = "gcr.io/${var.gcp_gcr_project_id}/${var.docker_image_name}:${var.docker_image_tag}"
  condition = var.provider == "gke"
}
