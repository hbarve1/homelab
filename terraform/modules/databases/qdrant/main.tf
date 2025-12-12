resource "helm_release" "qdrant" {
  name       = "qdrant"
  repository = "https://qdrant.github.io/qdrant-helm"
  chart      = "qdrant"
  version    = "1.16.1"
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml")
  ]
}
