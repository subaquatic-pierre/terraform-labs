resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana-community.github.io/helm-charts"
  chart      = "loki"
  namespace  = local.loki_ns
  version    = "18.5.0"

  values = [
    templatefile("${path.module}/values/loki-ss.yaml", {
      bucket_name_prefix = var.bucket_name_prefix
      aws_region         = var.aws_region
      aws_access_key     = var.aws_access_key
      aws_secret_key     = var.aws_secret_key
    })
  ]

  depends_on = [
    aws_s3_bucket.loki_chunks,
    aws_s3_bucket.loki_ruler
  ]
}
