variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
}

# AWS Secrets Manager
resource "aws_secretsmanager_secret" "example_secret" {
  count = var.provider == "eks" ? 1 : 0

  name       = "example-secret"
  description = "An example secret stored in AWS Secrets Manager"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  count  = var.provider == "eks" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = var.example_secret_value
}

# Google Secret Manager
resource "google_secret_manager_secret" "example_secret" {
  count = var.provider == "gke" ? 1 : 0

  secret_id = "example-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "example_secret_version" {
  count    = var.provider == "gke" ? 1 : 0
  secret   = google_secret_manager_secret.example_secret.id
  secret_data = base64encode(var.example_secret_value)
}
