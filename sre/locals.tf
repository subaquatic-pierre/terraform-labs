locals {
  loki_ns       = kubernetes_namespace_v1.loki.metadata[0].name
  mimir_ns      = kubernetes_namespace_v1.mimir.metadata[0].name
  monitoring_ns = kubernetes_namespace_v1.monitoring.metadata[0].name
}
