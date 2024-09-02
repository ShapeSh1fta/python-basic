resource "kubernetes_secret" "example_secret" {
  metadata {
    name      = "example-secret"
    namespace = kubernetes_namespace.default.metadata[0].name
  }

  data = {
    secret_key = module.secret_storage.example_secret_value
  }
}
