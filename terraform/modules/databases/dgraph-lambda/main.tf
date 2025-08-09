resource "helm_release" "dgraph_lambda" {
  name             = "dgraph-lambda"
  repository       = "https://charts.dgraph.io/"
  chart            = "dgraph-lambda"
  version          = "21.03.0"
  namespace        = "dgraph-lambda"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
