terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5"
    }
  }
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
