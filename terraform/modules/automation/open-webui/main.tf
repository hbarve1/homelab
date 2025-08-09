resource "helm_release" "open_webui" {
  name             = "open-webui"
  repository       = "https://open-webui.github.io/helm-charts/"
  chart            = "open-webui"
  version          = "0.1.0"
  namespace        = "open-webui"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
