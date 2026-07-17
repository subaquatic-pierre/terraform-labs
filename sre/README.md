### Alloy UI

```sh
kubectl port-forward -n monitoring svc/alloy 12345:12345
```

### Grafana UI

```sh
kubectl port-forward -n monitoring svc/grafana 5000:80
```

### Development

#### Update Helm values

```sh
helm upgrade loki grafana/loki \
  --namespace monitoring \
  --reuse-values \
  --set loki.storage.s3.insecure=true
```

#### Uninstall Chart

```sh
  helm uninstall loki
```

#### Delete Cluster

```sh
minikube delete
```

#### Start Minikube cluster

```sh
minikube start \
  --nodes=4 \
  --cni=flannel \
  --addons=volumesnapshots,csi-hostpath-driver \
  --extra-config=apiserver.storage-roles=true
```

#### Change storage drivers

```sh
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

minikube addons disable storage-provisioner
minikube addons disable default-storageclass
kubectl patch storageclass csi-hostpath-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
