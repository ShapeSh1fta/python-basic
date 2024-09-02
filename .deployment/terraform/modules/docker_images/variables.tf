variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
}

variable "docker_image_name" {
  description = "The name of the Docker image to be created"
  type        = string
}

variable "docker_image_tag" {
  description = "The tag of the Docker image to be created"
  type        = string
  default     = "latest"
}

variable "aws_ecr_repository_name" {
  description = "The name of the ECR repository (for AWS)"
  type        = string
  default     = "my-ecr-repository"
}

variable "gcp_gcr_project_id" {
  description = "The GCP project ID for the GCR repository (for GCP)"
  type        = string
}
