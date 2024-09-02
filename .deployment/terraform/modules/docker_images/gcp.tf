resource "google_container_registry" "example" {
  location = var.gcp_region
}

output "gcr_registry_url" {
  value = "gcr.io/${var.gcp_project_id}"
}
