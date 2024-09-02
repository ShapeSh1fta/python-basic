# AWS S3 Bucket Configuration
resource "aws_s3_bucket" "storage_bucket" {
  count = var.provider == "eks" ? 1 : 0

  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = var.bucket_name
    Environment = "Terraform"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.storage_bucket[0].bucket
  condition = var.provider == "eks"
}

# Google Cloud Storage Bucket Configuration
resource "google_storage_bucket" "storage_bucket" {
  count       = var.provider == "gke" ? 1 : 0
  name        = var.bucket_name
  location    = "US"
  project     = var.gcp_project_id
  force_destroy = true

  labels = {
    Name        = var.bucket_name
    Environment = "Terraform"
  }
}

output "gcs_bucket_name" {
  value = google_storage_bucket.storage_bucket[0].name
  condition = var.provider == "gke"
}
