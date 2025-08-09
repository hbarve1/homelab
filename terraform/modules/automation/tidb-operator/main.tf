resource "helm_release" "tidb_operator" {
  name             = "tidb-operator"
  repository       = "https://charts.pingcap.org/"
  chart            = "tidb-operator"
  version          = "1.5.3"
  namespace        = "tidb-operator"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
