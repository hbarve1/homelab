resource "helm_release" "presto" {
  name             = "presto"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "presto"
  version          = "5.5.2"
  namespace        = "presto"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
