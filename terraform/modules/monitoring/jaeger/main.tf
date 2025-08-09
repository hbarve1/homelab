resource "helm_release" "jaeger" {
  name             = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  version          = "0.71.13"
  namespace        = "tracing"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
