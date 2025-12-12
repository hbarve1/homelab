resource "helm_release" "mysql" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "mysql"
  version    = var.chart_version
  timeout    = 600

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      mysql_root_password = var.mysql_root_password
      mysql_database      = var.mysql_database
      storage_size        = var.storage_size
      mysql_version       = var.mysql_version
    })
  ]
}
