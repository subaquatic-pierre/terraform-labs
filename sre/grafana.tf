resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana-community.github.io/helm-charts"
  chart      = "grafana"
  namespace  = local.monitoring_ns
  version    = "12.7.2"

  values = [
    templatefile("${path.module}/values/grafana.yaml", {
      mimir_endpoint = "http://mimir-gateway.${local.monitoring_ns}.svc.cluster.local/prometheus"
      loki_endpoint  = "http://loki-gateway.${local.monitoring_ns}.svc.cluster.local"
    })
  ]

  depends_on = []
}
