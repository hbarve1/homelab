resource "helm_release" "oauth2_proxy" {
  name             = "oauth2-proxy"
  repository       = "https://oauth2-proxy.github.io/manifests"
  chart            = "oauth2-proxy"
  version          = "7.6.0"
  namespace        = "oauth2-proxy"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
