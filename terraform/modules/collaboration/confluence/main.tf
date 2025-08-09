resource "helm_release" "confluence" {
  name             = "confluence"
  repository       = "https://atlassian.github.io/data-center-helm-charts/"
  chart            = "confluence"
  version          = "1.19.0"
  namespace        = "confluence"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
