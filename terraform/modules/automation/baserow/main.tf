resource "helm_release" "baserow" {
  name             = "baserow"
  repository       = "https://charts.baserow.io/"
  chart            = "baserow"
  version          = "1.24.2"
  namespace        = "baserow"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
