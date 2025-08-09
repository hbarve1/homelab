resource "helm_release" "akhq" {
  name             = "akhq"
  repository       = "https://akhq.io/"
  chart            = "akhq"
  version          = "0.25.1"
  namespace        = "akhq"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
