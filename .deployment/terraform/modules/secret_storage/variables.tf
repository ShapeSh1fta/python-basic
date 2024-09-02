variable "example_secret_value" {
  description = "The value of the example secret"
  type        = string
}

variable "provider" {
  description = "Provider to deploy to (e.g., eks or gke)"
  type        = string
}
