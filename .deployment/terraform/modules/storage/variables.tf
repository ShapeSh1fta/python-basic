variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
}

variable "bucket_name" {
  description = "The name of the storage bucket to be created"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the S3 bucket will be created"
  type        = string
  default     = "us-west-2"
}

variable "gcp_project_id" {
  description = "The GCP project ID for creating the GCS bucket"
  type        = string
}
