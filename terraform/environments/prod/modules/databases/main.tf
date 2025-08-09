module "neo4j_initial" {
  source           = "../../../../modules/databases/neo4j"
  release_name     = "neo4j-production"
  namespace         = var.namespace
  neo4j_password   = var.neo4j_password
  neo4j_db         = "neo4j"
  storage_size     = "8Gi"
  advertised_host  = "pending"
}

data "kubernetes_service" "neo4j" {
  metadata {
    name      = "neo4j-production"
    namespace         = var.namespace
  }
  depends_on = [module.neo4j_initial]
}

resource "null_resource" "neo4j_upgrade" {
  depends_on = [data.kubernetes_service.neo4j]

  provisioner "local-exec" {
    command = "helm upgrade --namespace databases neo4j-production oci://registry-1.docker.io/bitnamicharts/neo4j --set advertisedHost=${data.kubernetes_service.neo4j.status[0].load_balancer[0].ingress[0].ip} --set neo4j.password=${var.neo4j_password} --set neo4j.database=neo4j --set persistence.size=8Gi"
  }
}

# Removed data.kubernetes_service.neo4j and null_resource.neo4j_upgrade since we do not need to fetch a LoadBalancer IP or run a manual helm upgrade. The ingress will handle external access.

# module "dgraph" {
#   source = "../databases/dgraph"
# }

# module "qdrant" {
#   source = "../databases/qdrant"
#   namespace = var.namespace
# }
