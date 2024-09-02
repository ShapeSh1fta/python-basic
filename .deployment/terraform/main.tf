variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
  default     = "eks"
}

provider "aws" {
  region = var.aws_region
  # Only initialize when provider is AWS
  count  = var.provider == "eks" ? 1 : 0
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  # Only initialize when provider is GCP
  count  = var.provider == "gke" ? 1 : 0
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}

# Conditional inclusion of provider-specific modules
module "provider_specific" {
  source = "./${var.provider}"

  providers = {
    aws      = aws
    google   = google
    kubernetes = kubernetes
  }
}

# Shared Modules
module "secret_storage" {
  source  = "./modules/secret_storage"
  provider = var.provider
  example_secret_value = "my-secret-value"
}


module "docker_images" {
  source                = "./modules/docker_image"
  provider              = var.provider
  docker_image_name     = var.docker_image_name
  docker_image_tag      = var.docker_image_tag
  aws_ecr_repository_name = var.aws_ecr_repository_name
  gcp_gcr_project_id    = var.gcp_gcr_project_id
}

module "storage" {
  source          = "./modules/storage"
  provider        = var.provider
  bucket_name     = var.bucket_name
  aws_region      = var.aws_region
  gcp_project_id  = var.gcp_project_id
}


output "provider_specific_outputs" {
  value = module.provider_specific
}

output "docker_image_url" {
  value = module.docker_images.ecr_repository_url != "" ? module.docker_images.ecr_repository_url : module.docker_images.gcr_registry_url
}

output "secrets" {
  description = "The value of the secret"
  value       = module.secret_storage.aws_secretsmanager_secret_version.secret_string != "" ? module.secret_storage.aws_secretsmanager_secret_version.secret_string : module.secret_storage.google_secret_manager_secret_version.secret_data
}

output "storage_bucket_name" {
  description = "The name of the storage bucket"
  value       = module.storage.s3_bucket_name != "" ? module.storage.s3_bucket_name : module.storage.gcs_bucket_name
}
