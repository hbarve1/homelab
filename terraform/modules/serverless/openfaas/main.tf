resource "helm_release" "openfaas" {
  name             = "openfaas"
  repository       = "https://openfaas.github.io/faas-netes/"
  chart            = "openfaas"
  version          = "14.2.131"
  namespace        = "openfaas"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
