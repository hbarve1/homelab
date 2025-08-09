resource "helm_release" "drone" {
  name             = "drone"
  repository       = "https://charts.drone.io"
  chart            = "drone"
  version          = "0.7.0"
  namespace        = "drone"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
