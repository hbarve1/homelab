resource "helm_release" "spark" {
  name             = "spark"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "spark"
  version          = "8.2.2"
  namespace        = "spark"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
