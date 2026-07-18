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

resource "kubernetes_secret_v1" "argocd_repo_creds" {
  metadata {
    name      = "private-repo-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    # Match this exactly to the repoURL used in your ApplicationSet
    url = "git@github.com:subaquatic-pierre/gitops-example.git"

    # Import your SSH private key from a local file
    sshPrivateKey = file("${path.module}/secrets/git_ssh.key")

    # insecureIgnoreHostKey = "true"

    # If need to get known hosts run
    # ssh-keyscan <your-git-server-domain>
    # then add the the sshKnownHosts

    # sshKnownHosts = "your-git-server-domain ssh-rsa AAAAB3..."
  }
}


resource "kubernetes_manifest" "applicationset_project_apps" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"
    metadata = {
      name      = "project-apps"
      namespace = "argocd"
    }
    spec = {
      generators = [
        {
          git = {
            repoURL  = "https://github.com/your-org/your-repo.git"
            revision = "main"
            directories = [
              {
                path = "environments/*/*"
              }
            ]
          }
        }
      ]
      template = {
        metadata = {
          name = "{{path[1]}}-{{path[2]}}"
        }
        spec = {
          project = "default"
          source = {
            repoURL        = "https://github.com/subaquatic-pierre/gitops-example.git"
            targetRevision = "main"
            path           = "{{path}}"
          }
          destination = {
            server = "https://kubernetes.default.svc"
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeel = true
            }
          }
        }
      }
    }
  }
}
