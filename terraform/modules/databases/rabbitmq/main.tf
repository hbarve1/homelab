resource "helm_release" "rabbitmq" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "rabbitmq"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      rabbitmq_password = var.rabbitmq_password
      storage_size      = var.storage_size
    })
  ]
}
