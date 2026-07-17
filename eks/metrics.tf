# Used with HPA to provide POD metrics for HorizontalPodAutoscaling
# resource to check required resources vs current used resources to 
#  determine whether to scale the pods in a deployment
resource "helm_release" "metrics_server" {
  name = "${aws_eks_cluster.eks.name}-metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.1"

  values = [
    yamlencode({
      defaultArgs = [
        "--cert-dir=/tmp",
        "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
        "--kubelet-use-node-status-port",
        "--metric-resolution=15s",
        "--secure-port=10250",
      ]
    })
  ]
}
