module "deployments" {
  source = "../shared/deployments.tf"
}

module "secrets" {
  source = "../shared/secrets.tf"
}
