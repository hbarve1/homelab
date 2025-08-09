resource "helm_release" "envoy" {
  name             = "envoy"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "envoy"
  version          = "1.34.0"
  namespace        = "envoy"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
