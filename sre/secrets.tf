resource "kubernetes_secret_v1" "mimir_s3" {
  metadata {
    name      = "aws-s3-secret"
    namespace = local.mimir_ns
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key
    AWS_SECRET_ACCESS_KEY = var.aws_secret_key
  }

  type = "Opaque"
}

