resource "helm_release" "fluent_bit" {
  name             = "fluent-bit"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  version          = "0.46.10"
  namespace        = "logging"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
