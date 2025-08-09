resource "helm_release" "kubeless" {
  name             = "kubeless"
  repository       = "https://kubeless.github.io/charts/"
  chart            = "kubeless"
  version          = "2.0.8"
  namespace        = var.namespace

  values = [
    file("${path.module}/values.yaml")
  ]
}
