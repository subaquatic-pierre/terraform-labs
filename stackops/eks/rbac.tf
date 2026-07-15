resource "kubernetes_namespace_v1" "development" {
  metadata {
    name = "development"
  }
}

resource "kubernetes_role_binding_v1" "developers" {
  metadata {
    name      = "developers"
    namespace = kubernetes_namespace_v1.development.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "eks-developers"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "edit"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding_v1" "admins" {
  metadata {
    name = "eks-admins"
  }

  subject {
    kind      = "Group"
    name      = "eks-admins"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding_v1" "viewers" {
  metadata {
    name = "eks-viewers"
  }

  subject {
    kind      = "Group"
    name      = "eks-viewers"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "view"
    api_group = "rbac.authorization.k8s.io"
  }
}
