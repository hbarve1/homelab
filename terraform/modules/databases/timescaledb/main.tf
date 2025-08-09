resource "helm_release" "timescaledb" {
  name             = "timescaledb"
  repository       = "https://charts.timescale.com/"
  chart            = "timescaledb-single"
  version          = "0.26.0"
  namespace        = "timescaledb"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
