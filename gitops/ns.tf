resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace_v1" "sealed_secrets" {
  metadata {
    name = "sealed-secrets"
  }
}

locals {
  argocd_ns      = kubernetes_namespace_v1.argocd.metadata[0].name
  sealed_secrets = kubernetes_namespace_v1.sealed_secrets.metadata[0].name
}
