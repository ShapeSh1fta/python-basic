module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 18.0"

  project_id     = var.gcp_project_id
  name           = "my-gke-cluster"
  region         = var.gcp_region
  network        = "default"
  subnetwork     = "default"
  ip_range_pods  = "default"
  ip_range_services = "default"
}

output "gke_cluster_name" {
  value = module.gke.name
}
