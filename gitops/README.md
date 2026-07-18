### Docker Secret

#### Pre-requisite

1. Ensure sealed secrets installed on cluster

```sh
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

helm install sealed-secrets sealed-secrets/sealed-secrets --namespace sealed-secrets --create-namespace
```

2. Install `kubeseal` cli

Docs here: https://github.com/bitnami/sealed-secrets/releases

```sh
curl -OL "https://github.com/bitnami/sealed-secrets/releases/download/v0.38.4/kubeseal-0.38.4-linux-amd64.tar.gz"
tar -xvzf kubeseal-0.38.4-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```

#### Create Secret

1. Create local base64 standard un-encrypted secret

```sh
kubectl create secret generic regcred \
  --from-file=.dockerconfigjson=/home/$(whoami)/.docker/roman/config.json \
  --type=kubernetes.io/dockerconfigjson \
  --namespace=project \
  --dry-run=client -o yaml > local-regcred.secret.yaml
```

2. Use kubeseal to encrypt secret

```sh
kubeseal --format yaml < local-regcred.secret.yaml > docker-regcred.yaml \
--controller-namespace sealed-secrets \
--controller-name sealed-secrets
```

### ArgoCD

#### Login:

- username: admin
- password: HtxCSqjZHX7JOQ7P
