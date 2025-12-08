# module "postgres_15" {
#   source            = "../databases/postgres"
#   release_name      = "postgres-15"
#   namespace         = var.namespace
#   postgres_user     = "admin"
#   postgres_password = var.postgres_password
#   postgres_db       = "postgres15"
#   storage_size      = "10Gi"
#   postgres_version  = "15"
# }

module "postgres_16" {
  source            = "../databases/postgres"
  release_name      = "postgres-16"
  namespace         = var.namespace
  postgres_user     = "admin"
  postgres_password = var.postgres_password
  postgres_db       = "postgres16"
  storage_size      = "10Gi"
  postgres_version  = "16"
}

module "postgres_17" {
  source            = "../databases/postgres"
  release_name      = "postgres-17"
  namespace         = var.namespace
  postgres_user     = "admin"
  postgres_password = var.postgres_password
  postgres_db       = "postgres17"
  storage_size      = "10Gi"
  postgres_version  = "17"
}

module "postgres_18" {
  source            = "../databases/postgres"
  release_name      = "postgres-18"
  namespace         = var.namespace
  postgres_user     = "admin"
  postgres_password = var.postgres_password
  postgres_db       = "postgres18"
  storage_size      = "10Gi"
  postgres_version  = "18"
}

# module "neo4j_initial" {
#   source           = "../databases/neo4j"
#   release_name     = "neo4j-dev"
#   namespace         = var.namespace
#   neo4j_password   = var.neo4j_password
#   neo4j_db         = "neo4j"
#   storage_size     = "8Gi"
#   advertised_host  = "pending"
# }

# data "kubernetes_service" "neo4j" {
#   metadata {
#     name      = "neo4j-dev"
#     namespace         = var.namespace
#   }
#   depends_on = [module.neo4j_initial]
# }

# resource "null_resource" "neo4j_upgrade" {
#   depends_on = [data.kubernetes_service.neo4j]

#   provisioner "local-exec" {
#     command = "helm upgrade --namespace databases neo4j-dev oci://registry-1.docker.io/bitnamicharts/neo4j --set advertisedHost=${data.kubernetes_service.neo4j.status[0].load_balancer[0].ingress[0].ip} --set neo4j.password=${var.neo4j_password} --set neo4j.database=neo4j --set persistence.size=8Gi"
#   }
# }

module "mysql_5" {
  source              = "./mysql"
  release_name        = "mysql-5"
  namespace           = var.namespace
  mysql_root_password = var.mysql_root_password
  mysql_database      = "mysql5"
  storage_size        = "8Gi"
  chart_version       = "9.19.1"
  mysql_version       = "5.7"
}

module "mysql_8" {
  source              = "./mysql"
  release_name        = "mysql-8"
  namespace           = var.namespace
  mysql_root_password = var.mysql_root_password
  mysql_database      = "mysql8"
  storage_size        = "8Gi"
  chart_version       = "9.19.1"
  mysql_version       = "8.0"
}

module "mysql_9" {
  source              = "./mysql"
  release_name        = "mysql-9"
  namespace           = var.namespace
  mysql_root_password = var.mysql_root_password
  mysql_database      = "mysql9"
  storage_size        = "8Gi"
  chart_version       = "9.19.1"
  mysql_version       = "9.0"
}

module "redis_6" {
  source           = "../databases/redis"
  release_name     = "redis-6"
  namespace        = var.namespace
  redis_password   = var.redis_password
  storage_size     = "8Gi"
  redis_version    = "6"
}

module "redis_7" {
  source           = "../databases/redis"
  release_name     = "redis-7"
  namespace        = var.namespace
  redis_password   = var.redis_password
  storage_size     = "8Gi"
  redis_version    = "7"
}

module "redis_8" {
  source           = "../databases/redis"
  release_name     = "redis-8"
  namespace        = var.namespace
  redis_password   = var.redis_password
  storage_size     = "8Gi"
  redis_version    = "8"
}

# module "elasticsearch" {
#   source                = "../databases/elasticsearch"
#   release_name          = "elasticsearch-dev"
#   namespace             = var.namespace
#   elasticsearch_password = var.elasticsearch_password
#   storage_size          = "8Gi"
# }

module "dgraph" {
  source = "./dgraph"
  namespace = var.namespace
}

module "qdrant" {
  source = "./qdrant"
  namespace = var.namespace
}

module "mongodb_8" {
  source = "./mongodb"
  release_name = "mongodb"
  namespace = var.namespace
  mongodb_root_password = var.mongodb_root_password
  mongodb_database = "mongodb"
  storage_size = "10Gi"
  mongodb_version = "8"
}
