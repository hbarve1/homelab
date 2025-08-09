# Terraform Structure for On-Prem Kubernetes Cluster

```
terraform/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── backend.tf
├── global/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── modules/
│   ├── compute/
│   │   └── ...
│   ├── network/
│   │   └── ...
│   ├── storage/
│   │   └── ...
│   ├── k8s_cluster/
│   │   └── ...
│   ├── monitoring/
│   │   └── ...
│   ├── ingress/
│   │   └── ...
│   ├── security/
│   │   └── ...
│   └── ...
├── scripts/
│   └── ...
└── README.md
```

- `environments/`: Per-environment Terraform configs (dev, prod, etc.)
- `global/`: Shared resources (DNS, monitoring, etc.)
- `modules/`: Reusable modules for compute, network, storage, k8s, etc.
- `scripts/`: Helper scripts for provisioning or automation.
