resource "helm_release" "dex" {
  name             = "dex"
  repository       = "https://charts.dexidp.io"
  chart            = "dex"
  version          = "0.16.0"
  namespace        = "dex"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
