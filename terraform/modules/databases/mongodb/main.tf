resource "helm_release" "mongodb" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "mongodb"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      mongodb_root_password = var.mongodb_root_password
      mongodb_database      = var.mongodb_database
      storage_size          = var.storage_size
      mongodb_username      = "admin"
      mongodb_user_database = var.mongodb_database
    })
  ]

  # Don't wait for all pods to be ready - MongoDB can take time to fully initialize
  wait = false
  timeout = 600
  
  # Allow partial failures - some pods may take longer to start
  atomic = false
}
