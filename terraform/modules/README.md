# Terraform Modules Structure

This directory contains all the Terraform modules organized by their primary function/purpose.

## Directory Structure

```
modules/
├── databases/          # Database-related modules (PostgreSQL, MySQL, MongoDB, etc.)
├── monitoring/         # Monitoring and observability tools
├── networking/         # Networking and service mesh components
├── storage/           # Storage solutions
├── security/          # Security and authentication tools
├── serverless/        # Serverless frameworks
├── ci-cd/             # Continuous Integration/Deployment tools
├── automation/        # Workflow automation tools
├── development/       # Development environment tools
├── ml-ai/             # Machine Learning and AI tools
├── analytics/         # Data processing and analytics tools
├── backup/            # Backup and disaster recovery solutions
├── cms/               # Content Management Systems
├── collaboration/     # Team collaboration tools
└── emulators/         # Cloud service emulators
```

## Module Categories

### Databases
- PostgreSQL
- MySQL
- MongoDB
- Neo4j
- Redis
- Elasticsearch
- RabbitMQ

### Monitoring
- Prometheus
- Grafana
- Elasticsearch
- Kibana
- Logstash
- Fluentd
- Fluent-bit
- Jaeger
- Zipkin
- OpenTelemetry
- Datadog
- New Relic

### Networking
- Istio
- Cilium
- Calico
- Flannel
- MetalLB
- HAProxy
- Envoy
- Kong
- Traefik
- NGINX Ingress
- Ambassador
- Linkerd

### Serverless
- Knative
- OpenFaaS
- Kubeless
- Fission

### CI/CD
- Jenkins
- GitLab
- GitLab CI
- Tekton
- Drone
- GitHub Actions Runner
- ArgoCD

### Development
- Code Server
- Jupyter
- Gitea
- Nexus

### ML/AI
- Kubeflow
- MLflow
- TensorFlow Serving
- PyTorch Serving

### Analytics
- Spark
- Flink
- Presto
- Trino
- ClickHouse

### Backup
- Kasten K10
- Stash
- Percona XtraBackup

### CMS
- WordPress
- Drupal
- MediaWiki

### Collaboration
- GitLab
- Confluence
- Jira

### Emulators
- LocalStack
- Azurite
- GCP Emulators

## Module Structure

Each module follows this structure:
```
module_name/
├── main.tf           # Main module configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
└── values.yaml       # Default values for the module
```

## Usage

To use a module, reference it in your environment's main.tf file:

```hcl
module "example" {
  source = "../../modules/category/module_name"
  
  # Module variables
  variable1 = "value1"
  variable2 = "value2"
}
``` 