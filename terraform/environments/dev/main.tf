terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# module "analytics" {
#   source    = "../../modules/analytics"
#   namespace = kubernetes_namespace.analytics.metadata[0].name
# }

module "databases" {
  source    = "../../modules/databases"
  namespace = kubernetes_namespace.databases.metadata[0].name
}

module "monitoring" {
  source    = "../../modules/monitoring"
  namespace = kubernetes_namespace.monitoring.metadata[0].name
}

module "automation" {
  source    = "../../modules/automation"
  namespace = kubernetes_namespace.automation.metadata[0].name
}

module networking {
  source    = "../../modules/networking"
  namespace = kubernetes_namespace.networking.metadata[0].name
}

module storage {
  source    = "../../modules/storage"
  namespace = kubernetes_namespace.storage.metadata[0].name
}

module serverless {
  source    = "../../modules/serverless"
  namespace = kubernetes_namespace.serverless.metadata[0].name
}

# module security {
#   source    = "../../modules/security"
#   namespace = kubernetes_namespace.security.metadata[0].name
# }

# module backup {
#   source    = "../../modules/backup"
#   namespace = kubernetes_namespace.backup.metadata[0].name
# }

# module "logstash" {
#   source = "../../modules/monitoring/logstash"
# }

# module "kibana" {
#   source = "../../modules/monitoring/kibana"
# }

# module "fluentd" {
#   source = "../../modules/monitoring/fluentd"
# }

# module "fluent_bit" {
#   source = "../../modules/monitoring/fluent-bit"
# }

# module "jaeger" {
#   source = "../../modules/monitoring/jaeger"
# }

# module "zipkin" {
#   source = "../../modules/monitoring/zipkin"
# }

# module "datadog" {
#   source = "../../modules/monitoring/datadog"
# }

# module "newrelic" {
#   source = "../../modules/monitoring/newrelic"
# }

# module "rabbitmq" {
#   source           = "../../modules/databases/rabbitmq"
#   release_name     = "rabbitmq-dev"
#   namespace        = kubernetes_namespace.databases.metadata[0].name
#   rabbitmq_password = var.rabbitmq_password
#   storage_size     = "8Gi"
# }

# module "grafana" {
#   source = "../../modules/monitoring/grafana"
# }

# module "prometheus" {
#   source = "../../modules/monitoring/prometheus"
# }

# module "opentelemetry" {
#   source     = "../../modules/monitoring/opentelemetry"
#   depends_on = [module.cert_manager]
# }

# module "cert_manager" {
#   source = "../../modules/monitoring/cert-manager"
# }

# module "n8n" {
#   source = "../../modules/automation/n8n"
# }

# module "docker_registry" {
#   source = "../../modules/development/nexus"
# }

# module "localstack" {
#   source = "../../modules/emulators/localstack"
# }

# module "velero" {
#   source = "../../modules/backup/velero"
# }

# module "minio" {
#   source = "../../modules/storage/minio"
# }

# module "openfga" {
#   source = "../../modules/security/openfga"
# }

# module "dgraph" {
#   source = "../../modules/databases/dgraph"
# }

# module "argocd" {
#   source = "../../modules/ci-cd/argocd"
# }

# module "kyverno" {
#   source = "../../modules/security/kyverno"
# }

# module "ingress" {
#   source = "../../modules/networking/ingress"
# }

# module "storage" {
#   source = "../../modules/storage"
# }

# module "network" {
#   source = "../../modules/networking"
# }

# module "istiod" {
#   source = "../../modules/networking/istio"
# }

# module "argo_workflows" {
#   source = "../../modules/automation/argo-workflows"
# }

# module "cilium" {
#   source = "../../modules/networking/cilium"
# }

# module "haproxy" {
#   source = "../../modules/network/haproxy"
# }

# module "envoy" {
#   source = "../../modules/network/envoy"
# }

# module "metallb" {
#   source = "../../modules/network/metallb"
# }

# module "calico" {
#   source = "../../modules/network/calico"
# }

# module "flannel" {
#   source = "../../modules/network/flannel"
# }

# module "harbor" {
#   source = "../../modules/development/harbor"
# }

# module "qdrant" {
#   source = "../../modules/databases/qdrant"
# }

# module "solr" {
#   source = "../../modules/databases/solr"
# }

# module "knative" {
#   source = "../../modules/serverless/knative"
# }

# module "openfaas" {
#   source = "../../modules/serverless/openfaas"
# }

# module "kubeless" {
#   source = "../../modules/serverless/kubeless"
# }

# module "fission" {
#   source = "../../modules/serverless/fission"
# }

# module "clickhouse" {
#   source = "../../modules/automation/clickhouse"
# }

# module "influxdb" {
#   source = "../../modules/automation/influxdb"
# }

# module "timescaledb" {
#   source = "../../modules/automation/timescaledb"
# }

# module "spark" {
#   source = "../../modules/automation/spark"
# }

# module "flink" {
#   source = "../../modules/automation/flink"
# }

# module "airflow" {
#   source = "../../modules/automation/airflow"
# }

# module "presto" {
#   source = "../../modules/automation/presto"
# }

# module "trino" {
#   source = "../../modules/automation/trino"
# }

# module "kasten_k10" {
#   source = "../../modules/automation/kasten-k10"
# }

# module "stash" {
#   source = "../../modules/automation/stash"
# }

# module "percona_xtrabackup" {
#   source = "../../modules/automation/percona-xtrabackup"
# }

# module "azurite" {
#   source = "../../modules/automation/azurite"
# }

# module "gcp_emulators" {
#   source = "../../modules/automation/gcp-emulators"
# }

# module "mongodb" {
#   source                = "../../modules/mongodb"
#   release_name          = "mongodb-dev"
#   namespace             = kubernetes_namespace.databases.metadata[0].name
#   mongodb_root_password = var.mongodb_root_password
#   mongodb_database      = "appdb"
#   storage_size          = "8Gi"
# }

# module "sonarqube" {
#   source = "../../modules/automation/sonarqube"
# }

# module "nexus" {
#   source = "../../modules/automation/nexus"
# }

# module "gitea" {
#   source = "../../modules/automation/gitea"
# }

# module "code_server" {
#   source = "../../modules/automation/code-server"
# }

# module "wordpress" {
#   source = "../../modules/automation/wordpress"
# }

# module "drupal" {
#   source = "../../modules/automation/drupal"
# }

# module "mediawiki" {
#   source = "../../modules/automation/mediawiki"
# }

# module "gitlab" {
#   source = "../../modules/automation/gitlab"
# }

# module "confluence" {
#   source = "../../modules/automation/confluence"
# }

# module "jira" {
#   source = "../../modules/automation/jira"
# }

# module "tf_serving" {
#   source = "../../modules/automation/tf-serving"
# }

# module "pytorch_serve" {
#   source = "../../modules/automation/pytorch-serving"
# }

# module "jupyter" {
#   source = "../../modules/automation/jupyter"
# }

# module "mlflow" {
#   source = "../../modules/automation/mlflow"
# }

# module "kubeflow" {
#   source = "../../modules/automation/kubeflow"
# }

# module "vault" {
#   source = "../../modules/automation/vault"
# }

# module "keycloak" {
#   source = "../../modules/automation/keycloak"
# }

# module "oauth2_proxy" {
#   source = "../../modules/automation/oauth2-proxy"
# }

# module "dex" {
#   source = "../../modules/automation/dex"
# }

# module "openldap" {
#   source = "../../modules/automation/openldap"
# }

# module "linkerd" {
#   source = "../../modules/network/linkerd"
# }

# module "kong" {
#   source = "../../modules/network/kong"
# }

# module "traefik" {
#   source = "../../modules/network/traefik"
# }

# module "nginx_ingress" {
#   source = "../../modules/network/nginx-ingress"
# }

# module "ambassador" {
#   source = "../../modules/network/ambassador"
# }

# module "jenkins" {
#   source = "../../modules/automation/jenkins"
# }

# module "gitlab_ci" {
#   source = "../../modules/automation/gitlab-ci"
# }

# module "tekton" {
#   source = "../../modules/automation/tekton"
# }

# module "drone" {
#   source = "../../modules/automation/drone"
# }

# module "github_actions_runner" {
#   source = "../../modules/automation/github-actions-runner"
# }

# module "ceph" {
#   source = "../../modules/storage/ceph"
# }

# module "openstack_swift" {
#   source = "../../modules/storage/openstack-swift"
# }

# module "memcached" {
#   source = "../../modules/automation/memcached"
# }

# module "etcd" {
#   source = "../../modules/automation/etcd"
# }

# module "couchdb" {
#   source = "../../modules/automation/couchdb"
# }

# module "cassandra" {
#   source = "../../modules/databases/cassandra"
# }

# module "mariadb" {
#   source = "../../modules/automation/mariadb"
# }

# module "sqlserver" {
#   source = "../../modules/automation/sqlserver"
# }

# module "akhq" {
#   source = "../../modules/analytics/akhq"
# }

# module "open_webui" {
#   source = "../../modules/automation/open-webui"
# }

# module "rabbitmq_cluster_operator" {
#   source = "../../modules/automation/rabbitmq-cluster-operator"
# }

# module "nats" {
#   source = "../../modules/automation/nats"
# }

# module "kafka" {
#   source = "../../modules/automation/kafka"
# }

# module "barman" {
#   source = "../../modules/backup/barman"
# }

# module "questdb" {
#   source = "../../modules/analytics/questdb"
# }

# module "redis_enterprise_operator" {
#   source = "../../modules/automation/redis-enterprise-operator"
# }

# module "baserow" {
#   source = "../../modules/automation/baserow"
# }

# module "starrocks" {
#   source = "../../modules/analytics/starrocks"
# }

# module "redisinsight_secure" {
#   source = "../../modules/automation/redisinsight-secure"
# }

# module "planetscale_vitess" {
#   source = "../../modules/automation/planetscale-vitess"
# }

# module "druid" {
#   source = "../../modules/analytics/druid"
# }

# module "doris" {
#   source = "../../modules/analytics/doris"
# }

# module "memgraph" {
#   source = "../../modules/analytics/memgraph"
# }

# module "dgraph_lambda" {
#   source = "../../modules/databases/dgraph-lambda"
# }

# module "kube_starrocks" {
#   source = "../../modules/analytics/kube-starrocks"
# }

# module "altinity_clickhouse_operator" {
#   source = "../../modules/analytics/altinity-clickhouse-operator"
# }

# module "tidb_operator" {
#   source = "../../modules/automation/tidb-operator"
# }

# module "nextcloud" {
#   source    = "../../modules/automation/nextcloud"
#   namespace = kubernetes_namespace.automation.metadata[0].name
# }

# All module blocks have been moved to subfiles in ./subfiles/ for better maintainability and readability.
