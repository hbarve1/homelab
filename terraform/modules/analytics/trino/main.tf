resource "helm_release" "trino" {
  name             = "trino"
  repository       = "https://trinodb.github.io/charts/"
  chart            = "trino"
  version          = "0.17.0"
  namespace        = "trino"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
