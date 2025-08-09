# On-Premises Kubernetes Cluster - Base Reference

This repository documents the setup and management of a comprehensive on-premises Kubernetes (K8s) cluster. It covers infrastructure, core services, security, monitoring, CI/CD, and best practices for a production-ready environment.

---

## Table of Contents

- [On-Premises Kubernetes Cluster - Base Reference](#on-premises-kubernetes-cluster---base-reference)
  - [Table of Contents](#table-of-contents)
  - [Cluster Architecture](#cluster-architecture)
  - [Core Components](#core-components)
  - [Networking](#networking)
  - [Storage](#storage)
  - [Authentication \& Security](#authentication--security)
  - [Monitoring \& Logging](#monitoring--logging)
  - [CI/CD \& GitOps](#cicd--gitops)
  - [Backup \& Disaster Recovery](#backup--disaster-recovery)
  - [Useful Add-ons](#useful-add-ons)
  - [Management \& Documentation](#management--documentation)
  - [References](#references)
  - [Database Deployments](#database-deployments)
    - [PostgreSQL on Kubernetes](#postgresql-on-kubernetes)

---

## Cluster Architecture

- **Kubernetes Distribution:** kubeadm / RKE2 / OpenShift
- **Nodes:** 3+ control plane, 3+ worker nodes (bare metal or VMs)
- **Load Balancer:** MetalLB / HAProxy / NGINX

---

## Core Components

- **Ingress Controller:** NGINX or Traefik
- **DNS:** CoreDNS
- **Certificate Management:** cert-manager
- **Dashboard:** Kubernetes Dashboard (secured)

---

## Networking

- **CNI:** Calico / Cilium / Flannel
- **Network Policies:** Enforced for pod security

---

## Storage

- **Dynamic Provisioning:** Longhorn / OpenEBS / Ceph
- **Shared Storage:** NFS / iSCSI

---

## Authentication & Security

- **RBAC:** Enabled and configured
- **OIDC Integration:** LDAP/AD/SSO
- **Pod Security:** Pod Security Admission / OPA Gatekeeper
- **Secrets Management:** HashiCorp Vault / Sealed Secrets
- **Image Scanning:** Trivy / Clair

---

## Monitoring & Logging

- **Monitoring:** Prometheus + Grafana
- **Logging:** EFK (Elasticsearch, Fluentd, Kibana) or Loki + Promtail + Grafana
- **Alerting:** Alertmanager

---

## CI/CD & GitOps

- **GitOps:** ArgoCD / Flux
- **CI/CD:** Jenkins / GitLab CI / Tekton
- **Helm:** For package management

---

## Backup & Disaster Recovery

- **Cluster Backup:** Velero
- **etcd Backup:** Regular snapshots

---

## Useful Add-ons

- **Metrics Server:** For HPA/VPA
- **Kube-state-metrics:** Cluster state metrics
- **Node Problem Detector:** Node health monitoring
- **Kured:** Automated node reboots
- **Service Mesh (optional):** Istio / Linkerd

---

## Management & Documentation

- **Cluster Management UI:** Rancher / Lens
- **Infrastructure Automation:** Ansible / Terraform

---

## References

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Awesome Kubernetes](https://github.com/ramitsurana/awesome-kubernetes)
- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [Velero](https://velero.io/)

---

## Database Deployments

### PostgreSQL on Kubernetes

This repository provides a reusable Terraform module to deploy PostgreSQL using the Bitnami Helm chart.

**Steps:**

1. Ensure your Kubernetes cluster is running and `kubectl`/`helm` are configured.
2. Configure your `terraform/environments/dev/main.tf` (or `prod/main.tf`) to use the Postgres module:

   ```hcl
   module "postgres" {
     source            = "../../modules/postgres"
     release_name      = "postgres-dev"
     namespace         = "databases"
     postgres_user     = "admin"
     postgres_password = var.postgres_password
     postgres_db       = "devdb"
     storage_size      = "20Gi"
   }
   ```

3. Set the `postgres_password` variable securely (e.g., via `terraform.tfvars` or environment variable).
4. Initialize and apply Terraform:

   ```sh
   cd terraform/environments/dev
   terraform init
   terraform apply
   ```

5. The module will install PostgreSQL in the specified namespace using Helm.

**Note:**  
- The Helm chart and values are customizable via the module variables.
- See `terraform/modules/postgres/` for details.

---

> **Note:** Customize this setup based on your organization’s requirements and security policies.
