locals {
  alloy_config = indent(6, join("\n\n", [
    templatefile("${path.module}/values/alloy/discovery.river", {}),
    templatefile("${path.module}/values/alloy/metrics.river", {
      scrape_interval = "15s"
      mimir_endpoint  = "http://mimir-gateway.${local.monitoring_ns}.svc.cluster.local/api/v1/push"
    }),
    templatefile("${path.module}/values/alloy/logs.river", {
      loki_endpoint = "http://loki-gateway.${local.monitoring_ns}.svc.cluster.local/loki/api/v1/push",
      cluster_name  = aws_eks_cluster.eks.name
    }),
    templatefile("${path.module}/values/alloy/loki.river", {}),
  ]))
}
resource "helm_release" "alloy" {
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  namespace  = local.monitoring_ns
  version    = "1.10.1"

  values = [
    templatefile("${path.module}/values/alloy.yaml", {
      alloy_config = local.alloy_config,
      namespace    = local.monitoring_ns
    }),
  ]

  depends_on = [
  ]
}
