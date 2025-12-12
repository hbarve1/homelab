resource "helm_release" "kafka" {
  name             = "kafka"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kafka"
  version          = "26.9.2"
  namespace        = "kafka"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
