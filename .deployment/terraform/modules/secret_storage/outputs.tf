# AWS Secrets Manager
output "example_secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.example_secret[0].arn
  condition   = var.provider == "eks"
}

# Google Secret Manager
output "example_secret_id" {
  description = "The ID of the secret in Google Secret Manager"
  value       = google_secret_manager_secret.example_secret[0].id
  condition   = var.provider == "gke"
}
