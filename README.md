# Terraform Labs

Welcome to **Terraform Labs**! This repository serves as a centralized collection of production-grade Terraform projects. These labs are designed to demonstrate best practices for provisioning and managing modern infrastructure, with a strong emphasis on **Kubernetes, GitOps, and Site Reliability Engineering (SRE)**.

The modules and configurations within this repository are structured to be directly applicable to real-world production environments, providing robust examples of Infrastructure as Code (IaC).

## 🚀 Projects Overview

This repository contains several dedicated projects, each focusing on a specific infrastructure domain:

- **`basic-webserver/`**: Provisioning of a fundamental AWS environment (VPC, Security Groups, SSH Keys) and EC2 instances for basic web hosting.
- **`eks/`**: A comprehensive Amazon EKS (Elastic Kubernetes Service) cluster setup. Includes node groups, RBAC, VPC configuration, and essential add-ons like the AWS Load Balancer Controller, Cluster Autoscaler, and Metrics Server.
- **`gitops/`**: Configurations and bootstrap code for establishing GitOps workflows to manage Kubernetes cluster states declaratively.
- **`sre/`**: An extensive observability and Site Reliability Engineering stack tailored for Kubernetes. Features monitoring, logging, and metrics aggregation utilizing tools like Grafana, Loki, Mimir, and Grafana Alloy.
- **`static-website/`**: Best-practice AWS architecture for hosting secure, performant static websites utilizing S3, CloudFront (CDN), ACM (SSL/TLS certificates), and Route53 (DNS).

## 🛠️ Development Environment Setup

To get started with local development and testing, particularly for the Kubernetes-focused projects, we recommend using **Minikube**. The `sre` directory contains prime examples of deploying an observability stack to a local cluster.

### Prerequisites

Ensure you have the following installed on your local machine:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.0)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/) (for chart management)

### Starting a Local Kubernetes Cluster (Minikube)

To spin up a local Minikube cluster with the necessary configurations (such as storage drivers required by Mimir and Loki), run the following commands:

```bash
# 1. Start the Minikube cluster with 4 nodes and specific configurations
minikube start \
  --nodes=4 \
  --cni=flannel \
  --addons=volumesnapshots,csi-hostpath-driver \
  --extra-config=apiserver.storage-roles=true

# 2. Enable required storage addons
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver

# 3. Disable default storage classes to prevent conflicts
minikube addons disable storage-provisioner
minikube addons disable default-storageclass

# 4. Patch the new CSI storage class to be the default
kubectl patch storageclass csi-hostpath-sc \
  -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

### Applying Terraform Configurations

Once your local cluster is running or your cloud credentials (e.g., AWS CLI) are configured, navigate to the specific project directory you wish to deploy:

```bash
# Example: Deploying the SRE stack locally
cd sre/

# Initialize the Terraform workspace
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

> **Note:** Cloud-based projects like `eks`, `basic-webserver`, and `static-website` will require valid AWS credentials configured in your environment and may incur cloud provider costs.

### Accessing Local Services (SRE Example)

When working with the `sre` stack locally on Minikube, you can easily port-forward to access the UIs. The `sre` directory includes a convenient Makefile for this:

```bash
cd sre/
make port-forward
```
This will run port-forwards in the background for Grafana (`localhost:5000`), Alloy UI (`localhost:5001`), and Mimir UI (`localhost:5002`).

## 💡 Best Practices Highlighted

Throughout these labs, you will find implementations of:
- **State Management**: Secure remote state handling and locking.
- **Modularity**: DRY (Don't Repeat Yourself) code using variables, locals, and modular design.
- **Security**: Least privilege IAM roles, secure networking (VPCs, private subnets), and encrypted storage.
- **GitOps & Automation**: Declarative infrastructure ready to be hooked into CI/CD or GitOps controllers.
- **Observability**: Built-in monitoring and logging to ensure system reliability (SRE principles).

---
*Maintained as a reference for Terraform Infrastructure as Code.*
