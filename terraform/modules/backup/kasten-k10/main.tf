resource "helm_release" "kasten_k10" {
  name             = "kasten-k10"
  repository       = "https://charts.kasten.io/"
  chart            = "k10"
  version          = "7.0.12"
  namespace        = "kasten-io"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
