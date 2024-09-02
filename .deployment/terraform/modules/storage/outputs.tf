# Output for AWS S3
output "s3_bucket_name" {
  description = "The name of the S3 bucket in AWS"
  value       = aws_s3_bucket.storage_bucket[0].bucket
  condition   = var.provider == "eks"
}

# Output for GCP GCS
output "gcs_bucket_name" {
  description = "The name of the GCS bucket in GCP"
  value       = google_storage_bucket.storage_bucket[0].name
  condition   = var.provider == "gke"
}
