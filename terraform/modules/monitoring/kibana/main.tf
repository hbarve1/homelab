resource "helm_release" "kibana" {
  name             = "kibana"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "kibana"
  version          = "10.5.2"
  namespace        = "elk"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
