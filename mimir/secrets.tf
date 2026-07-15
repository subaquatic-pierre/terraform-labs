resource "kubernetes_secret_v1" "mimir_s3" {
  metadata {
    name      = "mimir-s3"
    namespace = kubernetes_namespace_v1.monitoring.metadata[0].name
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key
    AWS_SECRET_ACCESS_KEY = var.aws_secret_key
  }

  type = "Opaque"
}
