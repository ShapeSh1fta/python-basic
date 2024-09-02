variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where the GKE cluster will be deployed"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "my-gke-cluster"
}

variable "network" {
  description = "The network to deploy the GKE cluster"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to deploy the GKE cluster"
  type        = string
  default     = "default"
}

variable "node_pools" {
  description = "Configuration for GKE node pools"
  type = map(object({
    node_count   = number
    machine_type = string
  }))
  default = {
    default_pool = {
      node_count   = 3
      machine_type = "e2-medium"
    }
  }
}
