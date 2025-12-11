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
- `docs/`: Documentation files

## Documentation

- **[Services Documentation](docs/services.md)** - Comprehensive list of all deployed and planned services

## Commands

- `terraform init` initializes the Terraform configuration.
- `terraform plan` creates an execution plan.
- `terraform apply` applies the changes.
- `terraform destroy` destroys the changes.
- `terraform show` shows the current state.
- `terraform state list` lists the resources in the state.
- `terraform state show` shows the current state of a resource.
- `terraform state pull` pulls the current state from the remote server.
- `terraform state push` pushes the current state to the remote server.
