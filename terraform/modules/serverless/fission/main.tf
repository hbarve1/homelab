resource "helm_release" "fission" {
  name             = "fission"
  repository       = "https://fission.github.io/fission-charts/"
  chart            = "fission-all"
  version          = "1.21.0"
  namespace        = "fission"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
