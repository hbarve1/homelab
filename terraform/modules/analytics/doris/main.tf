resource "helm_release" "doris" {
  name             = "doris"
  repository       = "https://apache.github.io/doris-helm/"
  chart            = "doris"
  version          = "1.2.2"
  namespace        = "doris"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
