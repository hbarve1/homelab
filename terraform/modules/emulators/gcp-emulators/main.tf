resource "helm_release" "gcp_emulators" {
  name             = "gcp-emulators"
  repository       = "https://charts.deliveryhero.io/"
  chart            = "gcp-emulators"
  version          = "0.2.0"
  namespace        = "gcp-emulators"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
