resource "kubernetes_deployment" "app" {
  for_each = var.deployments

  metadata {
    name = each.value.name
    labels = {
      app = each.value.name
    }
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = {
        app = each.value.name
      }
    }

    template {
      metadata {
        labels = {
          app = each.value.name
        }
      }

      spec {
        container {
          name  = each.value.name
          image = each.value.image

          port {
            container_port = each.value.port
          }

          env = [
            for k, v in each.value.env : {
              name  = k
              value = v
            }
          ]
        }
      }
    }
  }
}
