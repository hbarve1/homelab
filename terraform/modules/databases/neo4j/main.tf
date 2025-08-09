resource "helm_release" "neo4j" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "neo4j"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      neo4j_password  = var.neo4j_password
      neo4j_db       = var.neo4j_db
      storage_size   = var.storage_size
      advertised_host = var.advertised_host
    })
  ]
}

# resource "kubectl_manifest" "neo4j_ingress" {
#   yaml_body = templatefile("${path.module}/neo4j-ingress.yaml.tpl", {
#     namespace           = var.namespace
#     neo4j_host          = var.neo4j_host
#     neo4j_service_name  = helm_release.neo4j.name
#   })
# }

# resource "kubernetes_manifest" "neo4j_ingress" {
#   manifest = yamldecode(
#     templatefile("${path.module}/neo4j-ingress.yaml.tpl", {
#       namespace           = var.namespace
#       neo4j_host          = var.neo4j_host
#       neo4j_service_name  = helm_release.neo4j.name
#     })
#   )
# }