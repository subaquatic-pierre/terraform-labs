# AWS EKS

## Create kubectl config

```sh
aws eks update-kubeconfig --name $(terraform output -raw cluster_name)
```

## Examples

### Trigger Autoscale

```sh
k apply -f ../k8s/app-hpa/
k port-forward -n 3-example services/myapp 8080:8080
curl http://localhost:8080/api/cpu?index=44
```

### Deploy NextJS Static build

```sh
aws s3 sync out/ s3://$(terraform output -raw bucket_name) --delete
```

### Invalidate Cloudfront Cache

```sh
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw cloudfront_id) \
  --paths "/*"
```
