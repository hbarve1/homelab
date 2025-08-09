# TODOS

This document tracks the deployment progress of all core and auxiliary services in the on-premises Kubernetes cluster.

| Service                        | Category             | Deployment Progress |
|--------------------------------|----------------------|:------------------:|
| kubeadm/RKE2/OpenShift         | Cluster Provisioning | ⬜                 |
| MetalLB/HAProxy/NGINX          | Load Balancer        | ⬜                 |
| Calico/Cilium/Flannel          | Networking (CNI)     | ⬜                 |
| CoreDNS                        | DNS                  | ⬜                 |
| Longhorn/OpenEBS/Ceph          | Storage              | ⬜                 |
| NFS/iSCSI                      | Shared Storage       | ⬜                 |
| RBAC                           | Security             | ⬜                 |
| OIDC/LDAP/AD                   | Authentication       | ⬜                 |
| Pod Security Admission/OPA Gatekeeper | Security      | ⬜                 |
| HashiCorp Vault/Sealed Secrets | Secrets Mgmt         | ⬜                 |
| cert-manager                   | Certificate Mgmt     | ⬜                 |
| NGINX/Traefik                  | Ingress Controller   | ⬜                 |
| Prometheus                     | Monitoring           | ⬜                 |
| Grafana                        | Monitoring           | ⬜                 |
| Alertmanager                   | Monitoring           | ⬜                 |
| Metrics Server                 | Monitoring           | ⬜                 |
| Kube-state-metrics             | Monitoring           | ⬜                 |
| Node Problem Detector          | Monitoring           | ⬜                 |
| EFK/Loki+Promtail              | Logging              | ⬜                 |
| Velero                         | Backup/Recovery      | 🟡                 |
| etcd Backup                    | Backup/Recovery      | ⬜                 |
| Kured                          | Maintenance          | ⬜                 |
| Helm                           | Package Mgmt         | ⬜                 |
| ArgoCD/Flux                    | GitOps               | 🟡                 |
| Jenkins/GitLab CI/Tekton       | CI/CD                | ⬜                 |
| Kubernetes Dashboard           | Management UI        | ⬜                 |
| Rancher/Lens                   | Management UI        | ⬜                 |
| Istio/Linkerd                  | Service Mesh         | ⬜                 |
| Ansible/Terraform              | Automation           | ⬜                 |
| Trivy/Clair                    | Image Scanning       | ⬜                 |
| **PostgreSQL**                 | Database             | ⬜                 |
| **MySQL/MariaDB**              | Database             | ⬜                 |
| **MongoDB**                    | Database             | ⬜                 |
| **Redis**                      | Database             | ⬜                 |
| **Elasticsearch**              | Database             | ⬜                 |
| **Cassandra**                  | Database             | ⬜                 |
| **RabbitMQ**                   | Database/Queue       | ⬜                 |
| **Kafka**                      | Database/Queue       | ⬜                 |
| **Etcd**                       | Database             | ⬜                 |
| **ClickHouse**                 | Database             | ⬜                 |
| **InfluxDB**                   | Database             | ⬜                 |
| **TimescaleDB**                | Database             | ⬜                 |
| **Neo4j**                      | Database             | ⬜                 |
| **Memcached**                  | Database/Cache       | ⬜                 |
| LocalStack                      | Cloud Mocking        | 🟡                 |
| OpenFGA                         | Authorization        | 🟡                 |
| Dgraph                          | Graph Database       | 🟡                 |

**Legend:**  
⬜ Not Started | 🟡 In Progress | ✅ Completed

_Update the "Deployment Progress" column as you proceed with each service._