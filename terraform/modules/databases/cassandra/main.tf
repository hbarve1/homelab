resource "helm_release" "cassandra" {
  name             = "cassandra"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "cassandra"
  version          = "10.5.2"
  namespace        = "cassandra"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
