module "postgres" {
  source            = "../databases/postgres"
  release_name      = "postgres-dev"
  namespace         = var.namespace
  postgres_user     = "admin"
  postgres_password = var.postgres_password
  postgres_db       = "devdb"
  storage_size      = "20Gi"
}

module "neo4j_initial" {
  source           = "../databases/neo4j"
  release_name     = "neo4j-dev"
  namespace         = var.namespace
  neo4j_password   = var.neo4j_password
  neo4j_db         = "neo4j"
  storage_size     = "8Gi"
  advertised_host  = "pending"
}

data "kubernetes_service" "neo4j" {
  metadata {
    name      = "neo4j-dev"
    namespace         = var.namespace
  }
  depends_on = [module.neo4j_initial]
}

resource "null_resource" "neo4j_upgrade" {
  depends_on = [data.kubernetes_service.neo4j]

  provisioner "local-exec" {
    command = "helm upgrade --namespace databases neo4j-dev oci://registry-1.docker.io/bitnamicharts/neo4j --set advertisedHost=${data.kubernetes_service.neo4j.status[0].load_balancer[0].ingress[0].ip} --set neo4j.password=${var.neo4j_password} --set neo4j.database=neo4j --set persistence.size=8Gi"
  }
}

module "mysql_1" {
  source           = "../databases/mysql"
  release_name     = "mysql-1-dev"
  namespace        = var.namespace  
  mysql_root_password = var.mysql1_root_password
  mysql_database   = "appdb1"
  storage_size     = "8Gi"
  chart_version    = "9.19.1"
}

module "mysql_2" {
  source           = "../../modules/databases/mysql"
  release_name     = "mysql-2-dev"
  namespace        = var.namespace
  mysql_root_password = var.mysql2_root_password
  mysql_database   = "appdb2"
  storage_size     = "8Gi"
  chart_version    = "9.18.2"
}

module "redis" {
  source           = "../databases/redis"
  release_name     = "redis-dev"
  namespace         = var.namespace
  redis_password   = var.redis_password
  storage_size     = "8Gi"
}

module "elasticsearch" {
  source                = "../databases/elasticsearch"
  release_name          = "elasticsearch-dev"
  namespace             = var.namespace
  elasticsearch_password = var.elasticsearch_password
  storage_size          = "8Gi"
}

module "dgraph" {
  source = "../databases/dgraph"
}

module "qdrant" {
  source = "../databases/qdrant"
  namespace = var.namespace
}
