resource "helm_release" "logstash" {
  name             = "logstash"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "logstash"
  version          = "8.6.2"
  namespace        = "elk"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
