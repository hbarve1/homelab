resource "helm_release" "datadog" {
  name             = "datadog"
  repository       = "https://helm.datadoghq.com"
  chart            = "datadog"
  version          = "3.67.0"
  namespace        = "datadog"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
