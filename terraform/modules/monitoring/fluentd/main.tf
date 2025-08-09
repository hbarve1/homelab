resource "helm_release" "fluentd" {
  name             = "fluentd"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluentd"
  version          = "0.5.7"
  namespace        = "logging"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
