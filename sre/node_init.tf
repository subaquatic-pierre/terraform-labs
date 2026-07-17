resource "kubernetes_daemon_set_v1" "node_sysctl_init" {
  metadata {
    name      = "node-sysctl-init"
    namespace = "kube-system"
    labels = {
      name = "node-sysctl-init"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "node-sysctl-init"
      }
    }

    template {
      metadata {
        labels = {
          name = "node-sysctl-init"
        }
      }

      spec {
        host_pid     = true
        host_network = true

        init_container {
          name  = "sysctl-align"
          image = "busybox:1.36"
          command = [
            "sysctl",
            "-w",
            "fs.inotify.max_user_instances=131072",
            "fs.inotify.max_user_watches=524288"
          ]

          security_context {
            privileged = true
          }
        }

        container {
          name  = "pause"
          image = "registry.k8s.io/pause:3.9"
        }
      }
    }
  }
}
