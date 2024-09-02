provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.23.0"  # Replace with the latest version

  values = [
    <<EOF
server:
  service:
    type: LoadBalancer
  ingress:
    enabled: false
  config:
    url: https://argocd-server.${var.domain}
    insecure: true
EOF
  ]
}

output "argocd_server_url" {
  description = "ArgoCD server URL"
  value       = helm_release.argocd.status[*].url[0]
}
