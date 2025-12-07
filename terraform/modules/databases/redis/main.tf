resource "helm_release" "redis" {
  name       = var.release_name
  namespace  = var.namespace
  create_namespace = true
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      redis_password = var.redis_password
      storage_size   = var.storage_size
      redis_version  = var.redis_version
    })
  ]
}
