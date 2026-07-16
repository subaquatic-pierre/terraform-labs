locals {
  alloy_config = indent(6, join("\n\n", [
    templatefile("${path.module}/values/alloy/discovery.river", {}),
    templatefile("${path.module}/values/alloy/metrics.river", {
      scrape_interval = "15s"
      mimir_endpoint  = "http://mimir-gateway.${local.ns}.svc.cluster.local/api/v1/push"
  })]))
}
resource "helm_release" "alloy" {
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  namespace  = local.ns
  version    = "1.10.1"

  values = [
    templatefile("${path.module}/values/alloy.yaml", {
      alloy_config = local.alloy_config,
      namespace    = local.ns
    }),
  ]

  depends_on = [
  ]
}
