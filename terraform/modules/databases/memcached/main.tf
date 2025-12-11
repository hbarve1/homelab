resource "helm_release" "memcached" {
  name             = "memcached"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "memcached"
  version          = "7.6.0"
  namespace        = "memcached"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
