resource "helm_release" "sqlserver" {
  name             = "sqlserver"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "mssql"
  version          = "15.0.2"
  namespace        = "sqlserver"
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
