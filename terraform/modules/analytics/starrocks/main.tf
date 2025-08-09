resource "helm_release" "starrocks" {
  name             = "starrocks"
  repository       = "https://starrocks.github.io/helm-charts/"
  chart            = "starrocks"
  version          = "3.2.6"
  namespace        = "starrocks"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
