module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 18.0"

  project_id     = var.project_id
  name           = var.cluster_name
  region         = var.region
  network        = var.network
  subnetwork     = var.subnetwork
  node_pools     = var.node_pools
  ip_range_pods  = "default"
  ip_range_services = "default"
}
