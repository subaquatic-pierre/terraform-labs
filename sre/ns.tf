resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace_v1" "mimir" {
  metadata {
    name = "mimir"
  }
}

resource "kubernetes_namespace_v1" "loki" {
  metadata {
    name = "loki"
  }
}

