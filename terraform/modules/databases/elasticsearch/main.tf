resource "helm_release" "elasticsearch" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "elasticsearch"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      elasticsearch_password = var.elasticsearch_password
      storage_size           = var.storage_size
    })
  ]
}
