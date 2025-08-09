resource "helm_release" "kong" {
  name             = "kong"
  repository       = "https://charts.konghq.com"
  chart            = "kong"
  version          = "2.41.2"
  namespace        = "kong"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
