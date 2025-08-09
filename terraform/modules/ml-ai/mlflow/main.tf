resource "helm_release" "mlflow" {
  name             = "mlflow"
  repository       = "https://community-charts.github.io/helm-charts"
  chart            = "mlflow"
  version          = "2.3.0"
  namespace        = "mlflow"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
