resource "helm_release" "longhorn" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  version          = "1.6.2"
  namespace        = "longhorn-system"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
