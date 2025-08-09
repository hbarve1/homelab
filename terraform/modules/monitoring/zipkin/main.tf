resource "helm_release" "zipkin" {
  name             = "zipkin"
  repository       = "https://openzipkin.github.io/zipkin"
  chart            = "zipkin"
  version          = "0.4.0"
  namespace        = "tracing"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
