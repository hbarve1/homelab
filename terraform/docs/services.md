# Terraform Services Documentation

This document provides a comprehensive overview of all services in the Terraform homelab setup, with deployment status tracking.

## Service Status Legend

- **Status:** `Deployed` = Currently active, `Planned` = Module available but not deployed
- **Dev:** `✓` = Deployed in dev, `-` = Not deployed
- **Prod:** `✓` = Deployed in prod, `-` = Not deployed

## All Services

| Service Name | Category | Status | Dev | Prod | Description | Notes |
|--------------|----------|--------|-----|------|-------------|-------|
| **Databases** |
| PostgreSQL 16 | Databases | Deployed | ✓ | ✓ | PostgreSQL database version 16 | |
| PostgreSQL 17 | Databases | Deployed | ✓ | ✓ | PostgreSQL database version 17 | |
| PostgreSQL 18 | Databases | Deployed | ✓ | ✓ | PostgreSQL database version 18 | |
| PostgreSQL 15 | Databases | Planned | - | - | PostgreSQL database version 15 | |
| MySQL 5 | Databases | Deployed | ✓ | ✓ | MySQL database version 5.7 | |
| MySQL 8 | Databases | Deployed | ✓ | ✓ | MySQL database version 8.0 | |
| MySQL 9 | Databases | Deployed | ✓ | ✓ | MySQL database version 9.0 | |
| Redis 6 | Databases | Deployed | ✓ | ✓ | Redis cache/database version 6 | |
| Redis 7 | Databases | Deployed | ✓ | ✓ | Redis cache/database version 7 | |
| Redis 8 | Databases | Deployed | ✓ | ✓ | Redis cache/database version 8 | |
| MongoDB 8 | Databases | Deployed | ✓ | ✓ | NoSQL document database version 8 | |
| Dgraph | Databases | Deployed | ✓ | ✓ | Distributed graph database | |
| Dgraph Lambda | Databases | Planned | - | - | Dgraph with Lambda functions | |
| Qdrant | Databases | Deployed | ✓ | ✓ | Vector database for similarity search | |
| Neo4j | Databases | Planned | - | - | Graph database | |
| Elasticsearch | Databases | Planned | - | - | Search and analytics engine | |
| Cassandra | Databases | Planned | - | - | Distributed NoSQL database | |
| SQL Server | Databases | Planned | - | - | Microsoft SQL Server | |
| TimescaleDB | Databases | Planned | - | - | Time-series database extension for PostgreSQL | |
| Solr | Databases | Planned | - | - | Search platform built on Apache Lucene | |
| RabbitMQ | Databases | Planned | - | - | Message broker | |
| **Monitoring & Observability** |
| Grafana | Monitoring | Deployed | ✓ | - | Metrics visualization and dashboards | |
| Cert Manager | Monitoring | Deployed | ✓ | - | Certificate management for Kubernetes | |
| Prometheus | Monitoring | Planned | - | - | Metrics collection and alerting | |
| OpenTelemetry | Monitoring | Planned | - | - | Observability framework | Depends on Cert Manager |
| Logstash | Monitoring | Planned | - | - | Log processing pipeline | |
| Kibana | Monitoring | Planned | - | - | Data visualization for Elasticsearch | |
| Fluentd | Monitoring | Planned | - | - | Log aggregator | |
| Fluent Bit | Monitoring | Planned | - | - | Lightweight log processor | |
| Jaeger | Monitoring | Planned | - | - | Distributed tracing | |
| Zipkin | Monitoring | Planned | - | - | Distributed tracing | |
| Datadog | Monitoring | Planned | - | - | Monitoring and analytics platform | |
| New Relic | Monitoring | Planned | - | - | Application performance monitoring | |
| **Automation & Workflows** |
| n8n | Automation | Deployed | ✓ | - | Workflow automation platform | |
| Argo Workflows | Automation | Planned | - | - | Workflow engine for Kubernetes | |
| ArgoCD | Automation | Planned | - | - | GitOps continuous delivery | |
| Airflow | Automation | Planned | - | - | Workflow orchestration platform | |
| Baserow | Automation | Planned | - | - | Open-source Airtable alternative | |
| CouchDB | Automation | Planned | - | - | Document-oriented NoSQL database | |
| Dex | Automation | Planned | - | - | OpenID Connect identity provider | |
| Docker Registry | Automation | Planned | - | - | Container image storage | |
| ETCD | Automation | Planned | - | - | Distributed key-value store | |
| InfluxDB | Automation | Planned | - | - | Time-series database | |
| Kafka | Automation | Planned | - | - | Distributed event streaming platform | |
| Keycloak | Automation | Planned | - | - | Identity and access management | |
| MariaDB | Automation | Planned | - | - | MySQL fork database | |
| Memcached | Automation | Planned | - | - | Distributed memory caching | |
| NATS | Automation | Planned | - | - | Messaging system | |
| Nextcloud | Automation | Planned | - | - | File sharing and collaboration | |
| OAuth2 Proxy | Automation | Planned | - | - | Authentication proxy | |
| Open WebUI | Automation | Planned | - | - | Web UI for AI models | |
| OpenLDAP | Automation | Planned | - | - | LDAP directory service | |
| PlanetScale Vitess | Automation | Planned | - | - | MySQL-compatible database clustering | |
| RabbitMQ Cluster Operator | Automation | Planned | - | - | RabbitMQ cluster management | |
| Redis Enterprise Operator | Automation | Planned | - | - | Redis Enterprise management | |
| RedisInsight Secure | Automation | Planned | - | - | Redis management UI | |
| SonarQube | Automation | Planned | - | - | Code quality and security analysis | |
| TiDB Operator | Automation | Planned | - | - | TiDB database operator | |
| Vault | Automation | Planned | - | - | Secrets management | |
| **Networking** |
| Nginx Ingress | Networking | Deployed | ✓ | ✓ | Kubernetes ingress controller | |
| Pi-hole | Networking | Deployed | ✓ | ✓ | Local DNS server and ad blocker | |
| Ingress Services | Networking | Deployed | ✓ | ✓ | HTTP ingress resources | |
| Cloudflare Tunnel | Networking | Deployed | - | ✓ | Secure tunnel for exposing services | Enabled in prod only |
| Istio | Networking | Planned | - | - | Service mesh | |
| Cilium | Networking | Planned | - | - | eBPF-based networking | |
| HAProxy | Networking | Planned | - | - | Load balancer and proxy | |
| Envoy | Networking | Planned | - | - | Cloud-native edge and service proxy | |
| MetalLB | Networking | Planned | - | - | Load balancer for bare metal Kubernetes | |
| Calico | Networking | Planned | - | - | Network policy and networking | |
| Flannel | Networking | Planned | - | - | Container networking | |
| Kong | Networking | Planned | - | - | API gateway | |
| Traefik | Networking | Planned | - | - | Reverse proxy and load balancer | |
| Ambassador | Networking | Planned | - | - | Kubernetes-native API gateway | |
| Linkerd | Networking | Planned | - | - | Service mesh | |
| **Storage** |
| MinIO | Storage | Deployed | ✓ | ✓ | S3-compatible object storage | |
| OpenEBS | Storage | Deployed | ✓ | ✓ | Container-attached storage | |
| Ceph | Storage | Planned | - | - | Distributed storage system | |
| OpenStack Swift | Storage | Planned | - | - | Object storage | |
| Longhorn | Storage | Planned | - | - | Distributed block storage | |
| **Serverless** |
| OpenFaaS | Serverless | Deployed | ✓ | ✓ | Functions as a Service platform | |
| Knative | Serverless | Planned | - | - | Kubernetes-based serverless platform | |
| Kubeless | Serverless | Planned | - | - | Kubernetes-native serverless framework | |
| Fission | Serverless | Planned | - | - | Fast serverless functions for Kubernetes | |
| **Backup** |
| Barman | Backup | Planned | - | - | Backup and recovery manager for PostgreSQL | |
| Kasten K10 | Backup | Planned | - | - | Kubernetes backup and disaster recovery | |
| Stash | Backup | Planned | - | - | Backup operator for Kubernetes | |
| Percona XtraBackup | Backup | Planned | - | - | MySQL backup tool | |
| Velero | Backup | Planned | - | - | Kubernetes backup and migration | |
| **CI/CD** |
| Drone | CI/CD | Planned | - | - | Continuous integration platform | |
| GitHub Actions Runner | CI/CD | Planned | - | - | Self-hosted GitHub Actions runners | |
| GitLab | CI/CD | Planned | - | - | Complete DevOps platform | |
| GitLab CI | CI/CD | Planned | - | - | GitLab continuous integration | |
| Jenkins | CI/CD | Planned | - | - | Automation server | |
| Tekton | CI/CD | Planned | - | - | Kubernetes-native CI/CD | |
| **CMS** |
| Drupal | CMS | Planned | - | - | Content management framework | |
| MediaWiki | CMS | Planned | - | - | Wiki software | |
| WordPress | CMS | Planned | - | - | Content management system | |
| **Collaboration** |
| Confluence | Collaboration | Planned | - | - | Team collaboration and documentation | |
| Jira | Collaboration | Planned | - | - | Issue tracking and project management | |
| **Analytics** |
| ClickHouse | Analytics | Deployed | ✓ | - | Column-oriented database for analytics | |
| AKHQ | Analytics | Planned | - | - | Kafka GUI | |
| Altinity ClickHouse Operator | Analytics | Planned | - | - | ClickHouse operator | |
| Doris | Analytics | Planned | - | - | Real-time analytics database | |
| Druid | Analytics | Planned | - | - | Real-time analytics database | |
| Flink | Analytics | Planned | - | - | Stream processing framework | |
| Kube StarRocks | Analytics | Planned | - | - | StarRocks on Kubernetes | |
| Memgraph | Analytics | Planned | - | - | In-memory graph database | |
| Presto | Analytics | Planned | - | - | Distributed SQL query engine | |
| QuestDB | Analytics | Planned | - | - | Time-series database | |
| Spark | Analytics | Planned | - | - | Unified analytics engine | |
| StarRocks | Analytics | Planned | - | - | Real-time analytics database | |
| Trino | Analytics | Planned | - | - | Distributed SQL query engine | |
| **Development Tools** |
| Gitea | Development | Deployed | ✓ | ✓ | Self-hosted Git service | |
| Harbor | Development | Deployed | ✓ | ✓ | Container registry and vulnerability scanner | |
| Code Server | Development | Planned | - | - | VS Code in the browser | |
| Jupyter | Development | Planned | - | - | Interactive computing notebooks | |
| Nexus | Development | Planned | - | - | Repository manager | |
| **ML/AI** |
| Kubeflow | ML/AI | Planned | - | - | Machine learning toolkit for Kubernetes | |
| MLflow | ML/AI | Planned | - | - | Machine learning lifecycle platform | |
| PyTorch Serving | ML/AI | Planned | - | - | PyTorch model serving | |
| TensorFlow Serving | ML/AI | Planned | - | - | TensorFlow model serving | |
| **Security** |
| Kyverno | Security | Planned | - | - | Kubernetes policy engine | |
| OpenFGA | Security | Planned | - | - | Fine-grained authorization | |
| **Emulators** |
| LocalStack | Emulators | Deployed | ✓ | ✓ | Local AWS cloud stack emulator | |
| Azurite | Emulators | Planned | - | - | Azure Storage emulator | |
| GCP Emulators | Emulators | Planned | - | - | Google Cloud Platform emulators | |
| **Apps** |
| Simple API Server | Apps | Planned | - | - | Basic API server application | |

---

## Summary Statistics

### By Status
- **Deployed:** 25 services
- **Planned:** 100+ services

### By Environment
- **Dev Environment:** 20 services deployed
- **Prod Environment:** 15 services deployed

### By Category
- **Databases:** 20 services (11 deployed, 9 planned)
- **Monitoring:** 12 services (2 deployed, 10 planned)
- **Automation:** 30 services (1 deployed, 29 planned)
- **Networking:** 13 services (4 deployed, 9 planned)
- **Storage:** 5 services (2 deployed, 3 planned)
- **Serverless:** 4 services (1 deployed, 3 planned)
- **Backup:** 5 services (0 deployed, 5 planned)
- **CI/CD:** 6 services (0 deployed, 6 planned)
- **Analytics:** 13 services (1 deployed, 12 planned)
- **Development:** 5 services (2 deployed, 3 planned)
- **ML/AI:** 4 services (0 deployed, 4 planned)
- **Security:** 2 services (0 deployed, 2 planned)
- **CMS:** 3 services (0 deployed, 3 planned)
- **Collaboration:** 2 services (0 deployed, 2 planned)
- **Emulators:** 3 services (1 deployed, 2 planned)
- **Apps:** 1 service (0 deployed, 1 planned)

---

## Deployment Instructions

### To Deploy a Planned Service

1. Navigate to the appropriate environment directory:
   - Development: `environments/dev/`
   - Production: `environments/prod/`

2. Open `main.tf` and uncomment the module block for the desired service

3. If the service requires variables, ensure they are defined in `variables.tf`

4. Run Terraform commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. Update this document to mark the service as `Deployed` and add checkmarks (✓) in the appropriate environment columns

### Service Dependencies

Some services have dependencies:
- **OpenTelemetry** requires **Cert Manager**
- **Kibana** typically works with **Elasticsearch**
- **Grafana** often pairs with **Prometheus**

Check module documentation for specific dependency requirements.

---

## Notes

- Services are organized into modules under `/modules/` directory
- Each environment (dev/prod) can selectively enable services via `main.tf`
- Most planned services are commented out in the configuration files
- Update this table when deploying new services or changing deployment status
- Use the Notes column to track important information about each service

---

*Last Updated: Generated from Terraform configuration files*
