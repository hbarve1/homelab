resource "helm_release" "druid" {
  name             = "druid"
  repository       = "https://druid.apache.org/charts"
  chart            = "druid"
  version          = "0.44.0"
  namespace        = "druid"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
