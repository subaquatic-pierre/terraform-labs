# AWS EKS

Create kubectl config

```sh
aws eks update-kubeconfig --name $(terraform output -raw cluster_name)
```
