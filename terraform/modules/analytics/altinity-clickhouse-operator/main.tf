resource "helm_release" "altinity_clickhouse_operator" {
  name             = "altinity-clickhouse-operator"
  repository       = "https://altinity.github.io/clickhouse-operator"
  chart            = "altinity-clickhouse-operator"
  version          = "0.23.2"
  namespace        = "altinity-clickhouse-operator"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
