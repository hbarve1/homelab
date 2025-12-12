resource "helm_release" "harbor" {
  name             = "harbor"
  repository       = "https://helm.goharbor.io"
  chart            = "harbor"
  version          = "1.18.0"
  namespace        = "harbor"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
