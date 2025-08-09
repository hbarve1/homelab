resource "helm_release" "clickhouse" {
  name             = "clickhouse"
  repository       = "oci://registry-1.docker.io/bitnamicharts/clickhouse"
  chart            = "clickhouse"
  version          = "9.2.4"
  namespace        = "clickhouse"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
