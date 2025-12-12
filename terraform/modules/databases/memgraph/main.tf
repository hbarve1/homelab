resource "helm_release" "memgraph" {
  name             = "memgraph"
  repository       = "https://memgraph.github.io/helm-charts/"
  chart            = "memgraph"
  version          = "2.10.0"
  namespace        = "memgraph"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
