resource "helm_release" "mimir" {
  name       = "mimir"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "mimir-distributed"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  version    = "6.2.0-weekly.402"

  values = [
    templatefile("${path.module}/values/mimir.yaml", {
      minio = {
        enabled = false
      }

      gateway = {
        nginx = {
          config = {
            "enableIPv6" = false
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_secret_v1.mimir_s3
  ]
}
