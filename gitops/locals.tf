locals {
  argocd_ns = kubernetes_namespace_v1.argocd.metadata[0].name
}
