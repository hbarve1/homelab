resource "helm_release" "opentelemetry" {
  name             = "opentelemetry-operator"
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-operator"
  version          = "0.56.0"
  namespace        = "monitoring"
  create_namespace = false

  set {
    name  = "manager.resources.requests.cpu"
    value = "10m"
  }
  set {
    name  = "manager.resources.requests.memory"
    value = "64Mi"
  }
  set {
    name  = "manager.resources.limits.cpu"
    value = "50m"
  }
  set {
    name  = "manager.resources.limits.memory"
    value = "128Mi"
  }
  set {
    name  = "manager.collectorImage.repository"
    value = "otel/opentelemetry-collector"
  }
  set {
    name  = "manager.collectorImage.tag"
    value = "latest"
  }
}
