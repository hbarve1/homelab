resource "helm_release" "couchdb" {
  name             = "couchdb"
  repository       = "https://apache.github.io/couchdb-helm"
  chart            = "couchdb"
  version          = "4.4.2"
  namespace        = "couchdb"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
