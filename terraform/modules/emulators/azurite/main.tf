resource "helm_release" "azurite" {
  name             = "azurite"
  repository       = "https://truecharts.org"
  chart            = "azurite"
  version          = "5.0.19"
  namespace        = "azurite"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
