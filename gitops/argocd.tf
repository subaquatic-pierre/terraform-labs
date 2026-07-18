resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = local.argocd_ns
  version    = "10.1.4"

  values = [yamlencode(
    {
      server = {
        extraArgs = [
          "--insecure"
        ]
      }
    }
  )]
}
