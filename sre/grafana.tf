# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana-community.github.io/helm-charts"
#   chart      = "grafana-community"
#   namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
#   version    = "12.7.2"

#   values = [
#     templatefile("${path.module}/values/grafana.yaml",{})
#   ]

#   depends_on = [
#   ]
# }
