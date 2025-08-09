resource "helm_release" "flink" {
  name             = "flink"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "flink"
  version          = "2.1.2"
  namespace        = "flink"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
