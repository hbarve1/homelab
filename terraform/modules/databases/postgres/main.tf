resource "helm_release" "postgresql" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  version    = var.chart_version
  timeout    = 600

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      postgres_user     = var.postgres_user
      postgres_password = var.postgres_password
      postgres_db       = var.postgres_db
      storage_size      = var.storage_size
    })
  ]
}
