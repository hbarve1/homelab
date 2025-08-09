resource "helm_release" "ambassador" {
  name             = "ambassador"
  repository       = "https://app.getambassador.io"
  chart            = "ambassador"
  version          = "8.10.1"
  namespace        = "ambassador"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
