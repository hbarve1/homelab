resource "helm_release" "influxdb" {
  name             = "influxdb"
  repository       = "https://helm.influxdata.com/"
  chart            = "influxdb2"
  version          = "2.1.1"
  namespace        = "influxdb"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
