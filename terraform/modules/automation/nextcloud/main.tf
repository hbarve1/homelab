resource "helm_release" "nextcloud" {
  name             = "nextcloud"
  repository       = "https://nextcloud.github.io/helm/"
  chart            = "nextcloud"
  version          = "6.6.0"
  namespace        = var.namespace
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]
}
