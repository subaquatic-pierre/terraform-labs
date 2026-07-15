# resource "helm_release" "alloy" {
#   name       = "alloy"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "alloy"
#   namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
#   version    = "1.10.1"

#   values = [
#     templatefile("${path.module}/values/alloy.yaml", {
#       bucket_name    = var.bucket_name
#       aws_access_key = var.aws_access_key
#       aws_secret_key = var.aws_secret_key
#     })
#   ]

#   depends_on = [
#   ]
# }
