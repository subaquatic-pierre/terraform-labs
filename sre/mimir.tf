resource "helm_release" "mimir" {
  name       = "mimir"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "mimir-distributed"
  namespace  = local.mimir_ns
  version    = "6.2.0-weekly.402"

  values = [
    templatefile("${path.module}/values/mimir.yaml", {
      namespace          = local.mimir_ns
      bucket_name_prefix = var.bucket_name_prefix
      aws_access_key     = var.aws_access_key
      aws_secret_key     = var.aws_secret_key
    })
  ]

  depends_on = [
    kubernetes_secret_v1.mimir_s3,
    aws_s3_bucket.mimir_alert,
    aws_s3_bucket.mimir_block,
    aws_s3_bucket.mimir,
    aws_s3_bucket.mimir_ruler
  ]
}
