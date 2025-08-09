resource "helm_release" "newrelic" {
  name             = "newrelic"
  repository       = "https://helm-charts.newrelic.com"
  chart            = "nri-bundle"
  version          = "5.19.1"
  namespace        = "newrelic"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
