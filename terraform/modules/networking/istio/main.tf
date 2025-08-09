resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = "1.26.0"
  namespace        = "istio-system"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
