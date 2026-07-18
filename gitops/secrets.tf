resource "helm_release" "sealed_secrets" {
  name = "sealed-secrets"

  repository = "https://bitnami.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  namespace  = local.sealed_secrets
  version    = "2.18.6"
}
