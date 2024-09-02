variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
  default     = "eks"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "secret_storage_backend" {
  description = "Backend to use for secret storage"
  type        = string
  default     = "aws-secrets-manager"
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  default     = "my-cluster"
}

variable "vpc_id" {
  description = "The VPC ID where the cluster will be deployed (for EKS)"
  type        = string
}

variable "subnets" {
  description = "The subnets where the cluster will be deployed"
  type        = list(string)
}

variable "node_group_config" {
  description = "Configuration for EKS node groups"
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_type    = string
  }))
}

variable "node_pools" {
  description = "Configuration for GKE node pools"
  type = map(object({
    node_count   = number
    machine_type = string
  }))
}

variable "kubeconfig_path" {
  description = "Path to the Kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "domain" {
  description = "Domain name for ArgoCD server"
  type        = string
  default     = "my-domain.com"  # Replace with your domain
}

variable "deployments" {
  description = "A map of deployments with their configurations."
  type = map(object({
    name        = string
    replicas    = number
    image       = string
    port        = number
    env         = map(string)
  }))
}
